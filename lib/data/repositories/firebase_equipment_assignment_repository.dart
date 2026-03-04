import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment_assignment.dart';
import '../../domain/repositories/equipment_assignment_repository.dart';

/// Implémentation Firebase du repository d'assignment d'équipements.
class FirebaseEquipmentAssignmentRepository
    implements EquipmentAssignmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'equipment_assignments';

  FirebaseEquipmentAssignmentRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(_collection);

  @override
  Future<String> assignEquipment(EquipmentAssignment assignment) async {
    final docRef = _col.doc();
    
    await _firestore.runTransaction((transaction) async {
      // 1. Vérifier que l'équipement n'est pas déjà assigné pour ce créneau (date + slot)
      final existingAssignments = await _firestore
          .collection(_collection)
          .where('equipment_id', isEqualTo: assignment.equipmentId)
          .where('date_string', isEqualTo: assignment.dateString)
          .where('slot', isEqualTo: assignment.slot)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();
      
      if (existingAssignments.docs.isNotEmpty) {
        throw Exception('Cet équipement est déjà assigné pour ce créneau');
      }
      
      // 2. Vérifier le statut de l'équipement
      final equipmentDoc = await transaction.get(
        _firestore.collection('equipment').doc(assignment.equipmentId)
      );
      
      if (!equipmentDoc.exists) {
        throw Exception('Équipement introuvable');
      }
      
      final equipmentData = equipmentDoc.data() as Map<String, dynamic>;
      final currentStatus = equipmentData['status'] as String;
      
      if (currentStatus != 'available') {
        throw Exception('Équipement non disponible : statut actuel = $currentStatus');
      }
      
      // 3. Écrire l'assignment
      transaction.set(docRef, {
        ...assignment.toJson(),
        'id': docRef.id,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      
      // 4. Update statut équipement
      transaction.update(equipmentDoc.reference, {
        'status': 'reserved',
        'updated_at': FieldValue.serverTimestamp(),
      });
    });
    
    return docRef.id;
  }

  @override
  Future<void> cancelAssignment(String assignmentId) async {
    final doc = await _col.doc(assignmentId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final equipmentId = data['equipment_id'] as String;

    // Libérer l'équipement
    await _firestore.collection('equipment').doc(equipmentId).update({
      'status': 'available',
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Annuler l'assignment
    await _col.doc(assignmentId).update({
      'status': 'cancelled',
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> completeAssignment(String assignmentId) async {
    final doc = await _col.doc(assignmentId).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final equipmentId = data['equipment_id'] as String;

    // Libérer l'équipement
    await _firestore.collection('equipment').doc(equipmentId).update({
      'status': 'available',
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Marquer comme complété
    await _col.doc(assignmentId).update({
      'status': 'completed',
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<EquipmentAssignment>> getSessionAssignments(
      String sessionId) async {
    final snapshot = await _col
        .where('session_id', isEqualTo: sessionId)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    return snapshot.docs
        .map((doc) => EquipmentAssignment.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<EquipmentAssignment>> getStudentAssignments(
      String studentId) async {
    final snapshot = await _col
        .where('student_id', isEqualTo: studentId)
        .orderBy('date_timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => EquipmentAssignment.fromJson(doc.data()))
        .toList();
  }

  @override
  Stream<List<EquipmentAssignment>> watchSessionAssignments(String sessionId) {
    return _col
        .where('session_id', isEqualTo: sessionId)
        .where('status', whereIn: ['pending', 'confirmed'])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentAssignment.fromJson(doc.data()))
            .toList());
  }

  @override
  Stream<List<EquipmentAssignment>> watchStudentAssignments(String studentId) {
    return _col
        .where('student_id', isEqualTo: studentId)
        .orderBy('date_timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EquipmentAssignment.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<bool> isEquipmentAssigned({
    required String equipmentId,
    required String sessionId,
  }) async {
    final snapshot = await _col
        .where('equipment_id', isEqualTo: equipmentId)
        .where('session_id', isEqualTo: sessionId)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<List<String>> getAvailableEquipmentIds({
    required String sessionId,
    required String category,
  }) async {
    // Récupérer les équipements déjà assignés
    final assignedSnapshot = await _col
        .where('session_id', isEqualTo: sessionId)
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    final assignedIds = assignedSnapshot.docs
        .map((doc) => doc.data()['equipment_id'] as String)
        .toSet();

    // Récupérer les équipements disponibles de la catégorie
    final equipmentSnapshot = await _firestore
        .collection('equipment')
        .where('category_id', isEqualTo: category)
        .where('status', isEqualTo: 'available')
        .get();

    return equipmentSnapshot.docs
        .where((doc) => !assignedIds.contains(doc.id))
        .map((doc) => doc.id)
        .toList();
  }
}
