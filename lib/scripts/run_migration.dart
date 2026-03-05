/// Script de migration des équipements - À exécuter en production
///
/// Usage :
/// 1. Faire un backup Firestore d'abord
/// 2. Exécuter ce script depuis un écran admin ou en CLI
/// 3. Vérifier le résultat
///
/// IMPORTANT : Ce script est idempotent - il peut être exécuté plusieurs fois
/// sans danger car il skip les documents déjà migrés.
library;

import '../utils/migrate_equipment_data.dart';

Future<void> runMigration() async {
  print('🚀 Démarrage de la migration des équipements...');
  print('');

  // 1. Estimer la migration
  print('📊 Estimation en cours...');
  final estimate = await estimateMigration();
  print('   ${estimate.toString()}');
  print('');

  if (estimate.toMigrate == 0) {
    print('✅ Aucun document à migrer !');
    return;
  }

  // 2. Confirmer la migration
  print('⚠️  ATTENTION : Cette opération est IRREVERSIBLE sans backup !');
  print('   - ${estimate.toMigrate} groupes d\'équipements vont être migrés');
  print('   - ${estimate.totalIndividualItems} équipements individuels seront créés');
  print('');
  print('   Assurez-vous d\'avoir fait un backup Firestore avant de continuer.');
  print('');
  print('   Pour continuer, décommentez la ligne ci-dessous dans runMigration() :');
  print('   // final result = await migrateEquipmentData();');
  print('');

  // 3. Exécuter la migration (décommenter pour activer)
  // final result = await migrateEquipmentData();
  
  // 4. Afficher le résultat
  // print('');
  // print('📊 Résultat de la migration :');
  // print('   - Groupes migrés : ${result.migratedGroups}');
  // print('   - Déjà migrés/skip : ${result.skipped}');
  // print('   - Erreurs : ${result.errors}');
  // if (result.hasErrors) {
  //   print('');
  //   print('❌ Erreurs rencontrées :');
  //   for (final error in result.errorMessages) {
  //     print('   - $error');
  //   }
  // }
  // print('');
  // print(result.hasErrors ? '⚠️  Migration terminée avec erreurs' : '✅ Migration réussie !');

  print('');
  print('📝 Pour exécuter la migration :');
  print('   1. Ouvrir lib/scripts/run_migration.dart');
  print('   2. Décommenter les lignes indiquées');
  print('   3. Relancer ce script');
}
