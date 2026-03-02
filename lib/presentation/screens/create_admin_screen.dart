import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart';
import '../providers/auth_state_provider.dart';

/// Écran pour créer/nommer un nouvel administrateur
class CreateAdminScreen extends ConsumerStatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  ConsumerState<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends ConsumerState<CreateAdminScreen> {
  final _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Rechercher des utilisateurs par email ou nom
  Future<void> _searchUsers() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final usersRef = FirebaseFirestore.instance.collection('users');

      // Recherche par email
      final emailQuery = await usersRef
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();

      setState(() {
        _searchResults = emailQuery.docs;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de recherche: $e';
        _isSearching = false;
      });
    }
  }

  /// Promouvoir un utilisateur en admin
  Future<void> _promoteToAdmin(DocumentSnapshot userDoc) async {
    final userId = userDoc.id;
    final userEmail =
        (userDoc.data() as Map<String, dynamic>)['email'] ?? 'Inconnu';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la promotion'),
        content: Text(
          'Voulez-vous vraiment faire de $userEmail un administrateur ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _doPromoteToAdmin(userId, userEmail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Promouvoir'),
          ),
        ],
      ),
    );
  }

  Future<void> _doPromoteToAdmin(String userId, String userEmail) async {
    setState(() {
      _successMessage = null;
      _errorMessage = null;
    });

    try {
      // 1. Créer le document dans la collection 'admins'
      await FirebaseFirestore.instance.collection('admins').doc(userId).set({
        'email': userEmail,
        'uid': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': ref.read(currentUserProvider).value?.id ?? 'unknown',
      });
      debugPrint('✅ Document admins créé pour $userEmail');

      // 2. Mettre à jour le rôle dans le document user
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Rôle admin défini pour $userEmail');

      if (!mounted) return;

      setState(() {
        _successMessage = '✅ $userEmail est maintenant administrateur !';
        _searchResults = [];
        _searchController.clear();
      });

      if (!mounted) return;

      // 3. Afficher message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ $userEmail est maintenant administrateur !'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // 4. Attendre un peu puis déconnecter pour appliquer le nouveau rôle
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // 5. Déconnecter l'utilisateur pour qu'il se reconnecte avec le nouveau rôle
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signOut();
      debugPrint('✅ Utilisateur déconnecté');

      if (!mounted) return;

      // 6. Afficher message d'info
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '🔄 Veuillez vous reconnecter avec vos nouveaux droits',
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('❌ Erreur promotion: $e');

      if (!mounted) return;

      setState(() {
        _errorMessage = '❌ Erreur: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// Vérifier si un utilisateur est déjà admin
  Future<bool> _isAdmin(String userId) async {
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(userId)
        .get();
    return adminDoc.exists;
  }

  /// Vérifier le rôle d'un utilisateur dans users/
  Future<String> _getUserRole(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return 'unknown';

      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['role'] ?? 'student';
    } catch (e) {
      debugPrint('Erreur lecture rôle: $e');
      return 'error';
    }
  }

  /// Widget pour le bouton de droite (action)
  Widget _buildTrailingWidget(
    DocumentSnapshot userDoc,
    String userId,
    String userEmail,
    bool isAdminInCollection,
    String userRole,
    bool roleMismatch,
  ) {
    if (roleMismatch) {
      // Admin dans admins/ mais pas le bon rôle dans users/
      return ElevatedButton.icon(
        onPressed: () => _forceRoleUpdate(userId, userEmail),
        icon: const Icon(Icons.sync_problem),
        label: const Text('Corriger'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      );
    } else if (userRole == 'admin') {
      // Déjà admin
      return const Chip(
        label: Text(
          'Admin',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    } else {
      // Pas admin, bouton promouvoir
      return ElevatedButton.icon(
        onPressed: () => _promoteToAdmin(userDoc),
        icon: const Icon(Icons.person_add),
        label: const Text('Promouvoir'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      );
    }
  }

  /// Forcer la mise à jour du rôle admin
  Future<void> _forceRoleUpdate(String userId, String userEmail) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Correction du rôle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Mise à jour du rôle de $userEmail...'),
          ],
        ),
      ),
    );

    try {
      // Mettre à jour le rôle
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Rôle admin forcé pour $userEmail');

      if (!mounted) return;
      Navigator.pop(context); // Fermer le dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Rôle de $userEmail corrigé !'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Rafraîchir la liste
      _searchUsers();
    } catch (e) {
      debugPrint('❌ Erreur correction rôle: $e');

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erreur: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Couleur primaire par défaut
    final primaryColor = const Color(0xFF2196F3); // Bleu par défaut

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un administrateur'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Email ou nom',
                      hintText: 'recherche@example.com',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => _searchUsers(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isSearching ? null : _searchUsers,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: const Text('Rechercher'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages d'erreur/succès
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),

          if (_successMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                ],
              ),
            ),

          // Résultats de recherche
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Recherchez un utilisateur par email',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'puis cliquez sur "Promouvoir" pour en faire un admin',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final userDoc = _searchResults[index];
                      final userData = userDoc.data() as Map<String, dynamic>;
                      final email = userData['email'] ?? 'Inconnu';
                      final displayName = userData['display_name'] ?? email;
                      final userId = userDoc.id;

                      return FutureBuilder<bool>(
                        future: _isAdmin(userId),
                        builder: (context, snapshot) {
                          final isAdminInCollection = snapshot.data ?? false;

                          return FutureBuilder<String>(
                            future: _getUserRole(userId),
                            builder: (context, roleSnapshot) {
                              final userRole = roleSnapshot.data ?? 'student';
                              final roleMismatch =
                                  isAdminInCollection && userRole != 'admin';

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: isAdminInCollection
                                        ? Colors.red.shade100
                                        : primaryColor.withOpacity(0.1),
                                    child: Icon(
                                      isAdminInCollection
                                          ? Icons.admin_panel_settings
                                          : Icons.person,
                                      color: isAdminInCollection
                                          ? Colors.red.shade700
                                          : primaryColor,
                                    ),
                                  ),
                                  title: Text(displayName),
                                  subtitle: Row(
                                    children: [
                                      Text(email),
                                      if (roleMismatch) ...[
                                        const SizedBox(width: 8),
                                        const Chip(
                                          label: Text(
                                            'Rôle incorrect',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.orange,
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: _buildTrailingWidget(
                                    userDoc,
                                    userId,
                                    email,
                                    isAdminInCollection,
                                    userRole,
                                    roleMismatch,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
