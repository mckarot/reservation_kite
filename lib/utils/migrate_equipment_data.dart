import 'package:cloud_firestore/cloud_firestore.dart';

/// Résultat de la migration des équipements.
class MigrationResult {
  final int migratedGroups;
  final int skipped;
  final int errors;
  final List<String> errorMessages;

  MigrationResult({
    required this.migratedGroups,
    required this.skipped,
    required this.errors,
    required this.errorMessages,
  });

  bool get hasErrors => errors > 0;

  @override
  String toString() {
    return 'MigrationResult(migrated: $migratedGroups, skipped: $skipped, errors: $errors)';
  }
}

/// Migre les données d'équipement de l'ancien format (quantité globale)
/// vers le nouveau format (équipements individuels).
///
/// Ancien format :
/// ```
/// {
///   brand: "F-One",
///   model: "Bandit",
///   size: "12",
///   total_quantity: 7
/// }
/// ```
///
/// Nouveau format (7 documents individuels) :
/// ```
/// {
///   brand: "F-One",
///   model: "Bandit",
///   size: "12",
///   serial_number: "F-One-Bandit-001",
///   status: "available",
///   total_bookings: 0
/// }
/// ```
///
/// La migration est atomique par groupe d'équipements :
/// - Tous les nouveaux documents sont créés dans une batch
/// - L'ancien document est supprimé dans la même batch
/// - En cas d'erreur sur un groupe, on continue avec les autres
Future<MigrationResult> migrateEquipmentData({
  FirebaseFirestore? firestore,
  bool dryRun = false,
}) async {
  final fs = firestore ?? FirebaseFirestore.instance;
  final equipmentSnapshot = await fs.collection('equipment').get();

  int migratedCount = 0;
  int skippedCount = 0;
  int errorCount = 0;
  final List<String> errors = [];

  print('🔄 Début de la migration - ${equipmentSnapshot.docs.length} groupes d\'équipements');

  for (var doc in equipmentSnapshot.docs) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      final totalQuantity = data['total_quantity'] as int? ?? 0;

      // Déjà migré (pas de total_quantity ou total_quantity <= 0) → skip
      if (totalQuantity <= 0) {
        skippedCount++;
        continue;
      }

      print('🔄 Migration de ${data['brand']} ${data['model']} - $totalQuantity unités');

      if (dryRun) {
        print('   [DRY RUN] $totalQuantity documents auraient été créés');
        migratedCount++;
        continue;
      }

      // ATOMIQUE : créer tous les docs individuels + supprimer l'ancien
      // en une seule batch pour éviter les états intermédiaires
      final batch = fs.batch();

      for (int i = 1; i <= totalQuantity; i++) {
        final newRef = fs.collection('equipment').doc();
        final serialNumber = _generateSerialNumber(data, i);

        batch.set(newRef, {
          'category_id': data['category_id'] ?? 'unknown',
          'brand': data['brand'] ?? '',
          'model': data['model'] ?? '',
          'size': data['size'] ?? '0',
          'serial_number': serialNumber,
          'status': 'available',
          'notes': data['notes'] ?? '',
          'total_bookings': 0,
          'updated_at': FieldValue.serverTimestamp(),
          // Champ de traçabilité : d'où vient ce document
          'migrated_from': doc.id,
          'migration_date': FieldValue.serverTimestamp(),
        });
      }

      // Supprimer l'ancien dans la même batch
      batch.delete(doc.reference);

      await batch.commit();
      migratedCount++;
      print('✅ ${data['brand']} ${data['model']} : $totalQuantity unités créées');

    } catch (e, stack) {
      errorCount++;
      final msg = 'Erreur sur ${doc.id}: $e';
      errors.add(msg);
      print('❌ $msg');
      print(stack);
      // On continue — pas d'arrêt brutal sur une erreur unitaire
    }
  }

  final result = MigrationResult(
    migratedGroups: migratedCount,
    skipped: skippedCount,
    errors: errorCount,
    errorMessages: errors,
  );

  print('📊 Résultat de la migration : $result');
  return result;
}

/// Génère un numéro de série unique pour un équipement.
///
/// Format : BRAND-MODEL-NNN (ex: F-One-Bandit-001)
String _generateSerialNumber(Map<String, dynamic> data, int index) {
  final brand = (data['brand'] as String? ?? '').replaceAll(' ', '-').toUpperCase();
  final model = (data['model'] as String? ?? '').replaceAll(' ', '-').toUpperCase();
  final size = (data['size'] as String? ?? '0').replaceAll('.', '-');
  final paddedIndex = index.toString().padLeft(3, '0');
  
  return '$brand-$model-$size-$paddedIndex';
}

/// Vérifie l'état actuel des données et estime le travail de migration.
Future<MigrationEstimate> estimateMigration({
  FirebaseFirestore? firestore,
}) async {
  final fs = firestore ?? FirebaseFirestore.instance;
  final equipmentSnapshot = await fs.collection('equipment').get();

  int totalGroups = equipmentSnapshot.docs.length;
  int toMigrate = 0;
  int alreadyMigrated = 0;
  int totalIndividualItems = 0;

  for (var doc in equipmentSnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final totalQuantity = data['total_quantity'] as int? ?? 0;

    if (totalQuantity > 0) {
      toMigrate++;
      totalIndividualItems += totalQuantity;
    } else {
      alreadyMigrated++;
    }
  }

  return MigrationEstimate(
    totalGroups: totalGroups,
    toMigrate: toMigrate,
    alreadyMigrated: alreadyMigrated,
    totalIndividualItems: totalIndividualItems,
  );
}

/// Estimation de la migration.
class MigrationEstimate {
  final int totalGroups;
  final int toMigrate;
  final int alreadyMigrated;
  final int totalIndividualItems;

  MigrationEstimate({
    required this.totalGroups,
    required this.toMigrate,
    required this.alreadyMigrated,
    required this.totalIndividualItems,
  });

  @override
  String toString() {
    return 'MigrationEstimate(total: $totalGroups groupes, à migrer: $toMigrate, déjà migrés: $alreadyMigrated, items individuels: $totalIndividualItems)';
  }
}
