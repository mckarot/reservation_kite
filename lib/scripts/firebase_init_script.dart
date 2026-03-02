import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// Script d'initialisation Firebase pour le développement
/// 
/// Ce script crée :
/// - Le document admin pour l'utilisateur connecté
/// - Les paramètres par défaut de l'école
/// - Les couleurs de thème par défaut
/// 
/// ⚠️ À utiliser EN DÉVELOPPEMENT UNIQUEMENT
class FirebaseInitScript {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseInitScript()
      : _firestore = FirebaseFirestore.instance,
        _auth = FirebaseAuth.instance;

  /// Initialise tous les documents Firebase requis
  Future<Map<String, dynamic>> run() async {
    final results = <String, dynamic>{
      'success': true,
      'steps': <String>[],
      'errors': <String>[],
    };

    try {
      // Initialiser Firebase si pas déjà fait
      await _ensureFirebaseInitialized();

      // Vérifier qu'un utilisateur est connecté
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'steps': <String>[],
          'errors': ['Aucun utilisateur connecté. Veuillez vous connecter d\'abord.'],
        };
      }

      results['steps'].add('✅ Utilisateur connecté: ${user.email} (${user.uid})');

      // 1. Créer le document admin
      await _createAdminDocument(user, results);

      // 2. Créer les paramètres de l'école
      await _createSchoolSettings(results);

      // 3. Créer la configuration du thème
      await _createThemeConfig(results);

      // 4. Créer des packs de crédits par défaut
      await _createDefaultCreditPacks(results);

      results['steps'].add('✅ Initialisation terminée avec succès!');
    } catch (e) {
      results['success'] = false;
      results['errors'].add('Erreur: ${e.toString()}');
    }

    return results;
  }

  Future<void> _ensureFirebaseInitialized() async {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      // Déjà initialisé
    }
  }

  Future<void> _createAdminDocument(User user, Map<String, dynamic> results) async {
    try {
      final adminRef = _firestore.collection('admins').doc(user.uid);
      final doc = await adminRef.get();

      if (doc.exists) {
        results['steps'].add('⚠️ Document admin existe déjà pour ${user.email}');
      } else {
        await adminRef.set({
          'email': user.email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': 'firebase_init_script',
        });
        results['steps'].add('✅ Document admin créé pour ${user.email}');
      }
    } catch (e) {
      results['errors'].add('Erreur création admin: ${e.toString()}');
    }
  }

  Future<void> _createSchoolSettings(Map<String, dynamic> results) async {
    try {
      final settingsRef = _firestore.collection('settings').doc('school_config');
      final doc = await settingsRef.get();

      if (doc.exists) {
        results['steps'].add('⚠️ school_config existe déjà');
      } else {
        await settingsRef.set({
          'opening_hours': {
            'morning': {'start': '08:00', 'end': '12:00'},
            'afternoon': {'start': '13:00', 'end': '18:00'},
          },
          'days_off': <String>['Tuesday morning'],
          'max_students_per_instructor': 4,
          'weather_latitude': null,
          'weather_longitude': null,
          'weather_location_name': null,
          'updated_at': FieldValue.serverTimestamp(),
        });
        results['steps'].add('✅ school_config créé');
      }
    } catch (e) {
      results['errors'].add('Erreur création settings: ${e.toString()}');
    }
  }

  Future<void> _createThemeConfig(Map<String, dynamic> results) async {
    try {
      final themeRef = _firestore.collection('settings').doc('theme_config');
      final doc = await themeRef.get();

      if (doc.exists) {
        results['steps'].add('⚠️ theme_config existe déjà');
      } else {
        await themeRef.set({
          'primaryColor': 0xFF2196F3, // Bleu
          'secondaryColor': 0xFF03DAC6, // Cyan
          'accentColor': 0xFFFF5722, // Orange
          'themeMode': 'system', // system, light, dark
          'updated_at': FieldValue.serverTimestamp(),
        });
        results['steps'].add('✅ theme_config créé');
      }
    } catch (e) {
      results['errors'].add('Erreur création theme: ${e.toString()}');
    }
  }

  Future<void> _createDefaultCreditPacks(Map<String, dynamic> results) async {
    try {
      final packsRef = _firestore.collection('credit_packs');
      
      // Vérifier s'il y a déjà des packs
      final snapshot = await packsRef.limit(1).get();
      
      if (snapshot.docs.isNotEmpty) {
        results['steps'].add('⚠️ Des credit_packs existent déjà');
        return;
      }

      // Créer des packs par défaut
      final defaultPacks = [
        {'name': 'Pack Découverte', 'credits': 1, 'price': 5000, 'is_active': true},
        {'name': 'Pack Progression', 'credits': 5, 'price': 22500, 'is_active': true},
        {'name': 'Pack Passion', 'credits': 10, 'price': 40000, 'is_active': true},
        {'name': 'Pack Illimité', 'credits': 20, 'price': 70000, 'is_active': true},
      ];

      for (final pack in defaultPacks) {
        await packsRef.add({
          ...pack,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      results['steps'].add('✅ ${defaultPacks.length} credit_packs créés');
    } catch (e) {
      results['errors'].add('Erreur création credit_packs: ${e.toString()}');
    }
  }
}

/// Widget de bouton d'initialisation Firebase (DEBUG ONLY)
class FirebaseInitButton extends StatefulWidget {
  const FirebaseInitButton({super.key});

  @override
  State<FirebaseInitButton> createState() => _FirebaseInitButtonState();
}

class _FirebaseInitButtonState extends State<FirebaseInitButton> {
  bool _isLoading = false;
  List<String> _logs = [];
  bool _showLogs = false;

  Future<void> _runInit() async {
    setState(() {
      _isLoading = true;
      _logs = [];
      _showLogs = false;
    });

    try {
      final script = FirebaseInitScript();
      final results = await script.run();

      setState(() {
        _logs = List<String>.from(results['steps'] ?? []);
        if (results['errors'] != null) {
          _logs.addAll(List<String>.from(results['errors']));
        }
        _showLogs = true;
      });

      if (mounted && results['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Initialisation Firebase réussie!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erreur lors de l\'initialisation'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _logs.add('Erreur: ${e.toString()}');
        _showLogs = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _runInit,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.settings_backup_restore),
          label: Text(_isLoading ? 'Initialisation...' : '🔧 Init Firebase (DEV)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        if (_showLogs) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logs d\'initialisation'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        final isError = log.startsWith('❌') || log.startsWith('Erreur');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            log,
                            style: TextStyle(
                              color: isError ? Colors.red : null,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fermer'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.terminal, size: 16, color: Colors.grey.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'Voir les logs (${_logs.length})',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
