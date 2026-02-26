import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_kite/presentation/screens/registration_screen.dart';
import '../../data/providers/repository_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_passwordController.text.length < 6) {
      setState(
        () =>
            _errorMessage = "Le mot de passe doit faire au moins 6 caractères.",
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (user == null) {
        setState(() {
          _errorMessage = "Utilisateur non trouvé ou erreur de connexion.";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erreur : ${e.toString()}";
        _isLoading = false;
      });
    }
  }



  Future<void> _setupTestData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final batch = FirebaseFirestore.instance.batch();

      // 1. Settings
      final settingsRef = FirebaseFirestore.instance
          .collection('settings')
          .doc('school_config');
      batch.set(settingsRef, {
        'hours': {
          'morning': {'start': '08:00', 'end': '12:00'},
          'afternoon': {'start': '13:00', 'end': '18:00'},
        },
        'daysOff': [],
        'maxStudentsPerInstructor': 4,
        'updated_at': FieldValue.serverTimestamp(),
      });

      // 2. Users de test
      final users = FirebaseFirestore.instance.collection('users');
      batch.set(users.doc('demo_admin'), {
        'display_name': 'Admin Test',
        'email': 'admin@test.com',
        'role': 'admin',
        'created_at': FieldValue.serverTimestamp(),
        'last_seen': FieldValue.serverTimestamp(),
      });

      batch.set(users.doc('demo_moniteur'), {
        'display_name': 'Moniteur Test',
        'email': 'moniteur@test.com',
        'role': 'instructor',
        'created_at': FieldValue.serverTimestamp(),
        'last_seen': FieldValue.serverTimestamp(),
      });

      // 3. Matériel de l'école (Équipement)
      final equipment = FirebaseFirestore.instance.collection('equipment');
      batch.set(equipment.doc('demo_kite'), {
        'type': 'kite',
        'brand': 'F-One',
        'model': 'Bandit',
        'size': '9m',
        'status': 'available',
        'notes': 'Matériel école neuf',
        'updated_at': FieldValue.serverTimestamp(),
      });

      // 4. Inventaire Boutique (Produits)
      final products = FirebaseFirestore.instance.collection('products');
      batch.set(products.doc('wing_v3'), {
        'name': 'Wing Strike V3',
        'description': 'L\'aile de référence pour le freeride',
        'price': 94900, // 949.00€
        'category': 'wing',
        'condition': 'new',
        'stock_quantity': 3,
        'image_urls': [],
        'created_at': FieldValue.serverTimestamp(),
      });

      // 5. Catalogue de Packs
      final creditPacks = FirebaseFirestore.instance.collection('credit_packs');
      batch.set(creditPacks.doc('pack_1_unit'), {
        'name': '1 Séance',
        'credits': 1,
        'price': 50.0,
        'is_active': true,
      });
      batch.set(creditPacks.doc('pack_5_units'), {
        'name': 'Forfait 5 Séances',
        'credits': 5,
        'price': 225.0,
        'is_active': true,
      });
      batch.set(creditPacks.doc('pack_10_units'), {
        'name': 'Forfait 10 Séances',
        'credits': 10,
        'price': 400.0,
        'is_active': true,
      });

      await batch.commit();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚀 Données de test et collections initialisées !'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erreur d'initialisation : $e";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sailing, size: 64, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  const Text(
                    'Kite Reserve',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const Text(
                    'Migration Firebase v2',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('SE CONNECTER'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ));
                    },
                    child: const Text('PAS DE COMPTE ? CRÉER UN COMPTE'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _isLoading ? null : _setupTestData,
                        icon: const Icon(Icons.storage, size: 14),
                        label: const Text(
                          'Init Schéma',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
