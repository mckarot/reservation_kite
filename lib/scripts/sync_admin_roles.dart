import 'package:cloud_firestore/cloud_firestore.dart';

/// Script pour synchroniser les rôles entre collections `admins` et `users`
///
/// Ce script :
/// 1. Liste tous les documents dans `admins`
/// 2. Pour chaque admin, met à jour `users/{uid}.role` à 'admin'
///
/// Usage : À exécuter dans une Cloud Function ou script standalone
Future<void> syncAdminRoles() async {
  final firestore = FirebaseFirestore.instance;

  print('🔍 Récupération de tous les admins...');

  // Récupérer tous les documents dans admins
  final adminsSnapshot = await firestore.collection('admins').get();

  print('✅ ${adminsSnapshot.docs.length} admin(s) trouvé(s)');

  var updated = 0;
  var errors = 0;

  for (final adminDoc in adminsSnapshot.docs) {
    final userId = adminDoc.id;
    final email = (adminDoc.data())['email'] ?? 'inconnu';

    try {
      // Vérifier si le user existe
      final userDoc = await firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        print('⚠️ User $userId ($email) n\'existe pas dans users/');
        errors++;
        continue;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final currentRole = userData['role'] ?? 'student';

      if (currentRole == 'admin') {
        print('✅ $email est déjà admin');
        continue;
      }

      // Mettre à jour le rôle
      await firestore.collection('users').doc(userId).update({
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ $email promu admin (était $currentRole)');
      updated++;
    } catch (e) {
      print('❌ Erreur pour $email: $e');
      errors++;
    }
  }

  print('\n📊 Résumé :');
  print('  - Admins synchronisés: $updated');
  print('  - Erreurs: $errors');
}
