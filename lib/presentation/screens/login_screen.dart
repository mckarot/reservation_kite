import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_kite/presentation/screens/registration_screen.dart';
import '../../data/providers/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../widgets/language_selector.dart';

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
    final l10n = AppLocalizations.of(context);

    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = l10n.passwordHintError);
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
          _errorMessage = l10n.loginError;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "${l10n.genericError} : ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<void> _setupTestData() async {
    final l10n = AppLocalizations.of(context);

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
        SnackBar(
          content: Text('🚀 ${l10n.initSchemaSuccess}'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "${l10n.initSchemaError}: $e";
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeAsync = ref.watch(localeNotifierProvider);
    final currentLocale = localeAsync.value ?? const Locale('fr');
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.appName,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<Locale>(
              value: currentLocale,
              underline: const SizedBox(),
              icon: const Icon(Icons.language, color: Colors.blueGrey),
              items: const [
                DropdownMenuItem(value: Locale('fr'), child: Text('🇫🇷 FR')),
                DropdownMenuItem(value: Locale('en'), child: Text('🇬🇧 EN')),
                DropdownMenuItem(value: Locale('es'), child: Text('🇪🇸 ES')),
                DropdownMenuItem(value: Locale('pt'), child: Text('🇵🇹 PT')),
                DropdownMenuItem(value: Locale('zh'), child: Text('🇨🇳 ZH')),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  ref
                      .read(localeNotifierProvider.notifier)
                      .setLocale(locale.languageCode);
                }
              },
            ),
          ),
        ],
      ),
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
                  Text(
                    l10n.appName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loginTitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.emailLabel,
                      hintText: l10n.emailHint,
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.passwordLabel,
                      hintText: l10n.passwordHint,
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
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
                          : Text(l10n.loginButton),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text(l10n.noAccount),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _isLoading ? null : _setupTestData,
                        icon: const Icon(Icons.storage, size: 14),
                        label: Text(
                          l10n.initSchema,
                          style: const TextStyle(fontSize: 11),
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
