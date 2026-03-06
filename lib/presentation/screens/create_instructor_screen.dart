import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../providers/auth_state_provider.dart';

/// Écran pour créer/nommer un nouvel moniteur
class CreateInstructorScreen extends ConsumerStatefulWidget {
  const CreateInstructorScreen({super.key});

  @override
  ConsumerState<CreateInstructorScreen> createState() =>
      _CreateInstructorScreenState();
}

class _CreateInstructorScreenState
    extends ConsumerState<CreateInstructorScreen> {
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

  /// Promouvoir un utilisateur en moniteur
  Future<void> _promoteToInstructor(DocumentSnapshot userDoc) async {
    final userId = userDoc.id;
    final userEmail =
        (userDoc.data() as Map<String, dynamic>)['email'] ?? 'Inconnu';
    final l10n = AppLocalizations.of(context);
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la promotion'),
        content: Text(
          'Voulez-vous vraiment promouvoir $userEmail au rang de **moniteur** ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _doPromoteToInstructor(userId, userEmail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Promouvoir'),
          ),
        ],
      ),
    );
  }

  Future<void> _doPromoteToInstructor(String userId, String userEmail) async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _successMessage = null;
      _errorMessage = null;
    });

    try {
      // 1. Créer le document dans la collection 'instructors'
      await FirebaseFirestore.instance
          .collection('instructors')
          .doc(userId)
          .set({
            'email': userEmail,
            'uid': userId,
            'createdAt': FieldValue.serverTimestamp(),
            'createdBy': ref.read(currentUserProvider).value?.id ?? 'unknown',
          });
      debugPrint('✅ Document instructors créé pour $userEmail');

      // 2. Mettre à jour le rôle dans le document user
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'instructor',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Rôle moniteur défini pour $userEmail');

      if (!mounted) return;

      setState(() {
        _successMessage = '✅ $userEmail est maintenant moniteur !';
        _searchResults = [];
        _searchController.clear();
      });

      if (!mounted) return;

      // 3. Afficher message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ $userEmail est maintenant moniteur !'),
          backgroundColor: Theme.of(context).colorScheme.primary,
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
        SnackBar(
          content: Text(l10n.reconnectMessage),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          duration: const Duration(seconds: 3),
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
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// Vérifier si un utilisateur est déjà moniteur
  Future<bool> _isInstructor(String userId) async {
    final instructorDoc = await FirebaseFirestore.instance
        .collection('instructors')
        .doc(userId)
        .get();
    return instructorDoc.exists;
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
    bool isInstructorInCollection,
    String userRole,
    bool roleMismatch,
    Color secondaryColor,
  ) {
    if (roleMismatch) {
      // Moniteur dans instructors/ mais pas le bon rôle dans users/
      return ElevatedButton.icon(
        onPressed: () => _forceRoleUpdate(userId, userEmail),
        icon: const Icon(Icons.sync_problem),
        label: const Text('Corriger'),
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
        ),
      );
    } else if (userRole == 'instructor') {
      // Déjà moniteur
      return Chip(
        label: const Text(
          'Moniteur',
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        backgroundColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
    } else {
      // Pas moniteur, bouton promouvoir
      return ElevatedButton.icon(
        onPressed: () => _promoteToInstructor(userDoc),
        icon: const Icon(Icons.person_add),
        label: const Text('Promouvoir'),
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
        ),
      );
    }
  }

  /// Forcer la mise à jour du rôle moniteur
  Future<void> _forceRoleUpdate(String userId, String userEmail) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('Mise à jour du rôle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Correction du rôle pour...'),
          ],
        ),
      ),
    );

    try {
      // Mettre à jour le rôle
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': 'instructor',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Rôle moniteur forcé pour $userEmail');

      if (!mounted) return;
      Navigator.pop(context); // Fermer le dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Rôle corrigé pour $userEmail'),
          backgroundColor: Theme.of(context).colorScheme.primary,
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
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final secondaryColor = colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un moniteur'),
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Email de l\'utilisateur',
                      hintText: 'recherche@example.com',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search),
                  label: Text(l10n.searchButton),
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
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
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
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _successMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Recherchez un utilisateur par email',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Promouvez un utilisateur au rang de moniteur',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.7),
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
                      final email = userData['email'] ?? l10n.unknownUser;
                      final displayName = userData['display_name'] ?? email;
                      final userId = userDoc.id;

                      return FutureBuilder<bool>(
                        future: _isInstructor(userId),
                        builder: (context, snapshot) {
                          final isInstructorInCollection =
                              snapshot.data ?? false;

                          return FutureBuilder<String>(
                            future: _getUserRole(userId),
                            builder: (context, roleSnapshot) {
                              final userRole = roleSnapshot.data ?? 'student';
                              final roleMismatch =
                                  isInstructorInCollection &&
                                  userRole != 'instructor';

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: isInstructorInCollection
                                        ? secondaryColor.withOpacity(0.2)
                                        : Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                    child: Icon(
                                      isInstructorInCollection
                                          ? Icons.sports_kabaddi
                                          : Icons.person,
                                      color: isInstructorInCollection
                                          ? secondaryColor
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  title: Text(displayName),
                                  subtitle: Row(
                                    children: [
                                      Text(email),
                                      if (roleMismatch) ...[
                                        const SizedBox(width: 8),
                                        Chip(
                                          label: const Text(
                                            'Rôle incorrect',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: secondaryColor,
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
                                    isInstructorInCollection,
                                    userRole,
                                    roleMismatch,
                                    secondaryColor,
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
