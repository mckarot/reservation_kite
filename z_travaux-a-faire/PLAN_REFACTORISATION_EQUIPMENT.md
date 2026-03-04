# 📋 PLAN DE RÉFACTORISATION - GESTION PROFESSIONNELLE DU MATÉRIEL

**Date :** 4 mars 2026  
**Auteur :** Lead Dev Flutter Senior  
**Statut :** En attente de validation  
**Priorité :** Haute  
**Effort estimé :** 5-8 heures

---

## 🔍 PROBLÈME IDENTIFIÉ

### **Situation actuelle** ❌

```
Collection: /equipment/
└─ doc_1: { 
     brand: "F-One", 
     model: "Bandit", 
     size: "12", 
     total_quantity: 7 
   }
```

**Problème critique :** Quand 1 voile est en maintenance, **les 7 voiles deviennent indisponibles** car le système gère une **quantité globale** au lieu de **suivre chaque équipement individuellement**.

### **Impact métier**

| Scénario | Comportement actuel | Comportement attendu |
|----------|---------------------|----------------------|
| 1 voile en maintenance | ❌ 0/7 disponibles | ✅ 6/7 disponibles |
| 1 voile réservée | ❌ 0/7 disponibles | ✅ 6/7 disponibles |
| Suivi d'usure | ❌ Impossible | ✅ Par équipement |
| Historique maintenance | ❌ Global | ✅ Par équipement |

---

## ✅ SOLUTION PROPOSÉE

### **Nouveau modèle de données**

Chaque équipement physique aura un **ID unique** :

```
Collection: /equipment/
├─ kite_001: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-001", status: "available" }
├─ kite_002: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-002", status: "available" }
├─ kite_003: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-003", status: "maintenance" } ← Seul celui-ci est indisponible
├─ kite_004: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-004", status: "available" }
├─ kite_005: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-005", status: "available" }
├─ kite_006: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-006", status: "available" }
└─ kite_007: { brand: "F-One", model: "Bandit", size: "12", serial_number: "FO-2024-007", status: "available" }
```

---

## 📐 NOUVEAU SCHÉMA FIRESTORE

### **Collection : `equipment`**

| Champ | Type | Description | Exemple |
|-------|------|-------------|---------|
| `category_id` | string | FK → equipment_categories | `"kite"` |
| `brand` | string | Marque | `"F-One"` |
| `model` | string | Modèle | `"Bandit"` |
| `size` | string | Taille | `"12"` |
| `serial_number` | string? | **Numéro de série unique** | `"FO-2024-001"` |
| `status` | string | Statut | `"available"`, `"maintenance"`, `"damaged"`, `"reserved"` |
| `notes` | string | Notes | `""` |
| `purchase_date` | timestamp? | Date d'achat | `Timestamp` |
| `last_maintenance_date` | timestamp? | Dernière maintenance | `Timestamp` |
| `maintenance_history` | list<map> | Historique complet | `[{date, type, notes, cost}]` |
| `total_bookings` | int | Nombre de réservations | `42` |
| `updated_at` | timestamp | Dernière MAJ | `Timestamp` |

### **Collection : `equipment_bookings`**

| Champ | Type | Description |
|-------|------|-------------|
| `user_id` | string | FK → users.uid |
| `user_name` | string | Nom de l'élève |
| `user_email` | string | Email de l'élève |
| `equipment_id` | string | **FK → equipment.id (équipement physique spécifique)** |
| `equipment_type` | string | Copie pour requêtes rapides |
| `equipment_brand` | string | Copie pour affichage |
| `equipment_model` | string | Copie pour affichage |
| `equipment_size` | string | Copie pour affichage |
| `date_string` | string | Format 'yyyy-MM-dd' |
| `date_timestamp` | timestamp | Pour requêtes |
| `slot` | string | 'morning', 'afternoon', 'full_day' |
| `status` | string | 'confirmed', 'cancelled', 'completed' |
| `created_at` | timestamp | Création |
| `updated_at` | timestamp | MAJ |
| `created_by` | string | Créateur |
| `session_id` | string? | Session liée |
| `notes` | string? | Notes |

---

## 📋 PLAN D'IMPLÉMENTATION DÉTAILLÉ

### **PHASE 1 : Migration des données (1-2 heures)**

#### **1.1 Sauvegarde préalable**

```bash
# Export Firestore actuel
firebase firestore:export gs://reservation_kite/backups/equipment_backup_$(date +%Y%m%d)
```

#### **1.2 Script de migration**

**Fichier :** `lib/utils/migrate_equipment_data.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> migrateEquipmentData() async {
  final firestore = FirebaseFirestore.instance;
  final equipmentSnapshot = await firestore.collection('equipment').get();
  
  int migratedCount = 0;
  int errorCount = 0;
  
  for (var doc in equipmentSnapshot.docs) {
    try {
      final data = doc.data();
      final totalQuantity = data['total_quantity'] as int? ?? 1;
      
      if (totalQuantity > 1) {
        print('🔄 Migration de ${data['brand']} ${data['model']} (${data['size']}m²) - $totalQuantity unités');
        
        // Créer N documents individuels
        for (int i = 1; i <= totalQuantity; i++) {
          await firestore.collection('equipment').add({
            'category_id': data['category_id'],
            'brand': data['brand'],
            'model': data['model'],
            'size': data['size'],
            'serial_number': '${data['brand']}-${data['model']}-$i'.replaceAll(' ', '-'),
            'status': data['status'] ?? 'available',
            'notes': data['notes'] ?? '',
            'updated_at': FieldValue.serverTimestamp(),
          });
        }
        
        // Supprimer l'ancien document
        await doc.reference.delete();
        migratedCount++;
        
        print('✅ Migration terminée');
      }
    } catch (e) {
      errorCount++;
      print('❌ Erreur sur ${doc.id}: $e');
    }
  }
  
  print('📊 Résumé : $migratedCount documents migrés, $errorCount erreurs');
}
```

#### **1.3 Exécution de la migration**

```dart
// Dans un écran de debug ou script CLI
void _runMigration() async {
  await migrateEquipmentData();
  
  if (mounted) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Migration terminée'),
        content: const Text('Vérifiez les logs pour le détail'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

---

### **PHASE 2 : Mise à jour des modèles Flutter (30 min)**

#### **2.1 Nouveau modèle `Equipment`**

**Fichier :** `lib/domain/models/equipment.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment.freezed.dart';

enum EquipmentStatus {
  @JsonValue('available')
  available,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('damaged')
  damaged,
  @JsonValue('reserved')
  reserved,
}

@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String brand,
    required String model,
    required String size,
    @JsonKey(name: 'serial_number') String? serialNumber,
    required EquipmentStatus status,
    @Default('') String notes,
    @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
    @JsonKey(name: 'last_maintenance_date') DateTime? lastMaintenanceDate,
    @JsonKey(name: 'maintenance_history') List<MaintenanceHistory>? maintenanceHistory,
    @JsonKey(name: 'total_bookings') @Default(0) int totalBookings,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as String? ?? '',
      categoryId: (json['category_id'] ?? json['categoryId']) as String? ?? 'unknown',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      size: json['size'] as String? ?? '0',
      serialNumber: json['serial_number'] as String?,
      status: EquipmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EquipmentStatus.available,
      ),
      notes: json['notes'] as String? ?? '',
      purchaseDate: json['purchase_date'] is Timestamp
          ? (json['purchase_date'] as Timestamp).toDate()
          : null,
      lastMaintenanceDate: json['last_maintenance_date'] is Timestamp
          ? (json['last_maintenance_date'] as Timestamp).toDate()
          : null,
      maintenanceHistory: (json['maintenance_history'] as List?)
          ?.map((e) => MaintenanceHistory.fromJson(e))
          .toList(),
      totalBookings: json['total_bookings'] as int? ?? 0,
      updatedAt: json['updated_at'] is Timestamp
          ? (json['updated_at'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

@freezed
class MaintenanceHistory with _$MaintenanceHistory {
  const factory MaintenanceHistory({
    required DateTime date,
    required String type,
    required String notes,
    @Default(0) num cost,
  }) = _MaintenanceHistory;

  factory MaintenanceHistory.fromJson(Map<String, dynamic> json) {
    return MaintenanceHistory(
      date: (json['date'] as Timestamp).toDate(),
      type: json['type'] as String? ?? 'unknown',
      notes: json['notes'] as String? ?? '',
      cost: json['cost'] as num? ?? 0,
    );
  }
}
```

#### **2.2 Régénération du code**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### **PHASE 3 : Mise à jour des repositories (1 heure)**

#### **3.1 FirestoreEquipmentRepository**

**Fichier :** `lib/data/repositories/firestore_equipment_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/equipment.dart';
import '../../domain/repositories/equipment_repository.dart';

class FirestoreEquipmentRepository implements EquipmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'equipment';

  FirestoreEquipmentRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  @override
  Future<List<Equipment>> getAllEquipment() async {
    final snapshot = await _collection.limit(500).get();
    return snapshot.docs
        .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<Equipment?> getEquipment(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Equipment.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<List<Equipment>> getEquipmentByCategory(String categoryId) async {
    final snapshot = await _collection
        .where('category_id', isEqualTo: categoryId)
        .get();
    return snapshot.docs
        .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<List<Equipment>> getAvailableEquipment(String categoryId) async {
    final snapshot = await _collection
        .where('category_id', isEqualTo: categoryId)
        .where('status', isEqualTo: 'available')
        .get();
    return snapshot.docs
        .map((doc) => Equipment.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> saveEquipment(Equipment equipment) async {
    final data = {
      'id': equipment.id,
      'category_id': equipment.categoryId,
      'brand': equipment.brand,
      'model': equipment.model,
      'size': equipment.size,
      'serial_number': equipment.serialNumber,
      'status': equipment.status.name,
      'notes': equipment.notes,
      'purchase_date': equipment.purchaseDate != null 
          ? Timestamp.fromDate(equipment.purchaseDate!) 
          : null,
      'last_maintenance_date': equipment.lastMaintenanceDate != null 
          ? Timestamp.fromDate(equipment.lastMaintenanceDate!) 
          : null,
      'maintenance_history': equipment.maintenanceHistory
          ?.map((e) => {
            'date': Timestamp.fromDate(e.date),
            'type': e.type,
            'notes': e.notes,
            'cost': e.cost,
          }).toList(),
      'total_bookings': equipment.totalBookings,
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _collection.doc(equipment.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> updateStatus(String id, EquipmentStatus status) async {
    await _collection.doc(id).update({
      'status': status.name,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteEquipment(String id) async {
    await _collection.doc(id).delete();
  }

  /// Calcule le nombre d'équipements disponibles pour un type/créneau donné
  Future<int> getAvailableQuantity({
    required String categoryId,
    required DateTime date,
    required String slot,
  }) async {
    // 1. Récupérer tous les équipements de cette catégorie
    final allEquipment = await _collection
        .where('category_id', isEqualTo: categoryId)
        .get();
    
    // 2. Récupérer les réservations pour ce créneau
    final bookingsSnapshot = await _firestore
        .collection('equipment_bookings')
        .where('date_timestamp', isEqualTo: date)
        .where('slot', isEqualTo: slot)
        .where('status', whereIn: ['confirmed', 'pending'])
        .get();
    
    // 3. Compter les équipements réservés
    final reservedEquipmentIds = bookingsSnapshot.docs
        .map((doc) => doc.data()['equipment_id'] as String)
        .toSet();
    
    // 4. Compter les disponibles
    final availableCount = allEquipment.docs.where((doc) {
      final status = doc.data()['status'] as String;
      final id = doc.id;
      return status == 'available' && !reservedEquipmentIds.contains(id);
    }).length;
    
    return availableCount;
  }
}
```

---

### **PHASE 4 : Mise à jour des UI (2-3 heures)**

#### **4.1 EquipmentAdminScreen - Affichage du numéro de série**

**Fichier :** `lib/presentation/screens/equipment_admin_screen.dart`

```dart
ListTile(
  title: Text('${eq.brand} ${eq.model}'),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${eq.size}m²'),
      if (eq.serialNumber != null)
        Text(
          'S/N: ${eq.serialNumber}',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
    ],
  ),
  trailing: PopupMenuButton<EquipmentStatus>(
    // ...
  ),
)
```

#### **4.2 EquipmentBookingScreen - Affichage individuel**

**Fichier :** `lib/presentation/screens/equipment_booking_screen.dart`

```dart
Widget _buildEquipmentList(
  List<Equipment> equipment,
  AppLocalizations l10n,
  Color primaryColor,
) {
  final filtered = _selectedCategory != null
      ? equipment.where((e) => e.categoryId == _selectedCategory).toList()
      : equipment;

  if (filtered.isEmpty) {
    return Center(child: Text(l10n.noEquipmentAvailable));
  }

  return ListView.builder(
    itemCount: filtered.length,
    itemBuilder: (context, index) {
      final eq = filtered[index];
      
      return StreamBuilder<EquipmentWithAvailability>(
        stream: ref
            .read(equipmentAvailabilityNotifierProvider.notifier)
            .watchEquipmentAvailability(
              equipmentId: eq.id,
              date: _selectedDate,
              slot: _selectedSlot,
            ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          
          final availability = snapshot.data!;
          final isAvailable = availability.isAvailable;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(_getCategoryIcon(eq.categoryId)),
              ),
              title: Text('${eq.brand} ${eq.model}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAvailable
                        ? '${eq.size}m² - ${l10n.available}'
                        : '${eq.size}m² - ${l10n.unavailable}',
                  ),
                  if (eq.serialNumber != null)
                    Text(
                      'S/N: ${eq.serialNumber}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
              trailing: isAvailable
                  ? ElevatedButton(
                      onPressed: () => _confirmBooking(eq),
                      child: Text(l10n.rentButton),
                    )
                  : const Chip(label: Text('Indisponible')),
            ),
          );
        },
      );
    },
  );
}
```

#### **4.3 LessonValidationScreen - Sélection multiple**

**Fichier :** `lib/presentation/screens/lesson_validation_screen.dart`

```dart
// Le moniteur peut sélectionner PLUSIEURS équipements individuels
_EquipmentReservationSection(
  selectedEquipmentIds: _selectedEquipmentIds,
  onEquipmentSelected: (equipmentId) {
    setState(() => _selectedEquipmentIds.add(equipmentId));
  },
  onEquipmentRemoved: (equipmentId) {
    setState(() => _selectedEquipmentIds.remove(equipmentId));
  },
  selectedDate: widget.reservation.date,
  selectedSlot: EquipmentBookingSlot.morning,
),
```

---

### **PHASE 5 : Tests et validation (1-2 heures)**

#### **5.1 Tests unitaires**

**Fichier :** `test/repositories/equipment_repository_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentRepository - getAvailableQuantity', () {
    test('retourne le bon nombre déquipements disponibles', () async {
      // Setup : 7 voiles, 2 réservées
      await createEquipment('kite', 'F-One', '12', 7);
      await createBooking(equipmentId: 'kite_001', date: today, slot: 'morning');
      await createBooking(equipmentId: 'kite_002', date: today, slot: 'morning');
      
      // Test
      final available = await repository.getAvailableQuantity(
        categoryId: 'kite',
        date: today,
        slot: 'morning',
      );
      
      expect(available, 5); // 7 - 2 = 5
    });

    test('retourne 0 si tous réservés', () async {
      await createEquipment('kite', 'F-One', '12', 3);
      await createBooking(equipmentId: 'kite_001', date: today, slot: 'morning');
      await createBooking(equipmentId: 'kite_002', date: today, slot: 'morning');
      await createBooking(equipmentId: 'kite_003', date: today, slot: 'morning');
      
      final available = await repository.getAvailableQuantity(
        categoryId: 'kite',
        date: today,
        slot: 'morning',
      );
      
      expect(available, 0);
    });

    test('gère correctement la maintenance', () async {
      await createEquipment('kite', 'F-One', '12', 5);
      await updateStatus('kite_001', EquipmentStatus.maintenance);
      
      final available = await repository.getAvailableQuantity(
        categoryId: 'kite',
        date: today,
        slot: 'morning',
      );
      
      expect(available, 4); // 5 - 1 (maintenance) = 4
    });
  });
}
```

#### **5.2 Tests d'intégration**

**Scénario de test :**

1. ✅ Créer 7 équipements identiques (F-One Bandit 12m²)
2. ✅ Réserver 1 équipement pour demain matin
3. ✅ Vérifier que 6/7 restent disponibles
4. ✅ Mettre 1 équipement en maintenance
5. ✅ Vérifier que 5/7 restent disponibles
6. ✅ Annuler la réservation
7. ✅ Vérifier que 6/7 redeviennent disponibles

---

## 📊 TABLEAU COMPARATIF

| Fonctionnalité | Avant ❌ | Après ✅ |
|----------------|----------|----------|
| **ID unique** | Non (groupé) | Oui (individuel) |
| **Suivi individuel** | Non | Oui (serial_number) |
| **Maintenance** | Tous indisponibles | 1 seul indisponible |
| **Réservation** | Sur quantité | Sur équipement spécifique |
| **Historique** | Global | Par équipement |
| **Statistiques** | Limitées | Précises (total_bookings) |
| **QR Code / Scan** | Non possible | Possible (serial_number) |
| **Assurance** | Difficile | Facile (S/N unique) |
| **Inventaire physique** | Complexe | Simple (scan S/N) |

---

## 🎯 AVANTAGES DU NOUVEAU SYSTÈME

1. ✅ **Précision** : Chaque équipement est suivi individuellement
2. ✅ **Maintenance** : 1 voile en maintenance ≠ 7 voiles indisponibles
3. ✅ **Traçabilité** : Historique par équipement (usure, pannes, coûts)
4. ✅ **Statistiques** : Quel modèle est le plus réservé ? Quel S/N tombe souvent en panne ?
5. ✅ **Évolutif** : Possibilité d'ajouter QR codes / scan code-barres
6. ✅ **Conforme** : Standards professionnels de gestion de stock
7. ✅ **Assurance** : Chaque équipement est identifiable uniquement
8. ✅ **Inventaire** : Scan rapide des numéros de série

---

## ⚠️ POINTS DE VIGILANCE

| Risque | Impact | Mitigation |
|--------|--------|------------|
| Perte de données | Critique | Sauvegarde Firestore avant migration |
| Performance requêtes | Moyen | Index Firestore sur `serial_number`, `category_id`, `status` |
| Confusion utilisateurs | Faible | Formation + UI claire avec S/N |
| Temps de migration | Moyen | Tester en local d'abord |
| Rétrocompatibilité | Moyen | Gérer les 2 formats pendant transition |

---

## 📝 CHECKLIST D'IMPLÉMENTATION

### **Pré-migration**
- [ ] **1. Sauvegarde Firestore** (export JSON/GCS)
- [ ] **2. Test du script en local** (émulateur Firestore)
- [ ] **3. Communication aux utilisateurs** (maintenance prévue)

### **Migration**
- [ ] **4. Exécution du script** (environnement de prod)
- [ ] **5. Vérification des données** (compter avant/après)
- [ ] **6. Rollback plan** (si problème)

### **Développement**
- [ ] **7. Mise à jour modèles** (`Equipment`, `MaintenanceHistory`)
- [ ] **8. Mise à jour repositories** (`saveEquipment`, `getAvailableQuantity`)
- [ ] **9. Mise à jour providers** (`EquipmentNotifier`, `EquipmentAvailabilityNotifier`)
- [ ] **10. Mise à jour UI** (`EquipmentAdminScreen`, `EquipmentBookingScreen`, `LessonValidationScreen`)

### **Tests**
- [ ] **11. Tests unitaires** (couverture > 80%)
- [ ] **12. Tests d'intégration** (scénarios réels)
- [ ] **13. Tests manuels** (flux complet)

### **Déploiement**
- [ ] **14. Déploiement progressif** (10% utilisateurs)
- [ ] **15. Monitoring** (logs, erreurs, performance)
- [ ] **16. Documentation** (guide admin, FAQ)

---

## 📅 ESTIMATION TEMPS

| Phase | Tâches | Durée |
|-------|--------|-------|
| **1. Migration** | Sauvegarde, script, test | 1-2h |
| **2. Modèles** | Equipment, MaintenanceHistory | 30min |
| **3. Repositories** | CRUD, getAvailableQuantity | 1h |
| **4. UI** | 3 écrans à mettre à jour | 2-3h |
| **5. Tests** | Unitaires, intégration | 1-2h |
| **TOTAL** | | **5-8 heures** |

---

## 🚀 PROCHAINES ÉTAPES

1. **Valider ce plan** avec l'équipe
2. **Planifier la migration** (créneau de maintenance)
3. **Commencer l'implémentation** (Phase 1 → Phase 5)
4. **Tester en staging** avant production
5. **Déployer progressivement**

---

## 📞 CONTACT

Pour toute question sur ce plan d'implémentation, contacter l'équipe de développement.

---

**Document créé le :** 4 mars 2026  
**Dernière mise à jour :** 4 mars 2026  
**Version :** 1.0
