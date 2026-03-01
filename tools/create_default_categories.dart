// Script de création des catégories d'équipement par défaut
// Usage : dart tools/create_default_categories.dart

import 'package:cloud_firestore/cloud_firestore.dart';

const defaultCategories = [
  {'name': 'Kites', 'order': 1},
  {'name': 'Foils', 'order': 2},
  {'name': 'Planches', 'order': 3},
  {'name': 'Harnais', 'order': 4},
  {'name': 'Combinaisons', 'order': 5},
  {'name': 'Accessoires', 'order': 6},
];

Future<void> main() async {
  print('🚀 Création des catégories d\'équipement par défaut...');

  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection('equipment_categories');

  for (final category in defaultCategories) {
    final docRef = collection.doc();
    final data = {
      'name': category['name'],
      'order': category['order'],
      'isActive': true,
      'equipmentIds': [],
      'created_at': FieldValue.serverTimestamp(),
    };

    await docRef.set(data);
    print('✅ Catégorie créée : ${category['name']} (ordre: ${category['order']})');
  }

  print('✅ ${defaultCategories.length} catégories créées avec succès !');
  print('🎉 Terminé !');
}
