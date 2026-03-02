import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../data/providers/repository_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../widgets/colored_input_decoration.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  File? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfilePicture(String userId) async {
    if (_image == null) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child('$userId.jpg');
      await storageRef.putFile(_image!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context);
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = l10n.passwordsMismatch;
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authRepo = ref.read(authRepositoryProvider);
        final userCredential = await authRepo.signUpWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
          role: 'student',
          displayName: _displayNameController.text.trim(),
          weight: int.tryParse(_weightController.text),
        );

        if (userCredential != null) {
          final photoUrl = await _uploadProfilePicture(userCredential.id);
          if (photoUrl != null) {
            await authRepo.updateUserProfile(userCredential.id, {
              'photo_url': photoUrl,
            });
          }
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.accountCreatedSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _errorMessage = '${l10n.genericError} : ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Récupérer les couleurs du thème dynamique
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    
    // Utiliser les couleurs du thème ou les défauts
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    final secondaryColor = themeSettings?.secondary ?? AppThemeSettings.defaultSecondary;
    final accentColor = themeSettings?.accent ?? AppThemeSettings.defaultAccent;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Fond clair par défaut
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: null, // Désactivé - ne fait rien au clic
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: secondaryColor.withOpacity(0.3),
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : null,
                        child: _image == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: primaryColor.withOpacity(0.5),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _displayNameController,
                      decoration: createColoredInputDecoration(
                        labelText: l10n.fullNameLabel,
                        hintText: l10n.fullNameHint,
                        prefixIcon: Icon(Icons.person, color: primaryColor),
                        primaryColor: primaryColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fullNameHint;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: createColoredInputDecoration(
                        labelText: l10n.emailLabel,
                        hintText: l10n.emailHint,
                        prefixIcon: Icon(Icons.email, color: primaryColor),
                        primaryColor: primaryColor,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return l10n.emailHint;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: createColoredInputDecoration(
                        labelText: l10n.passwordLabel,
                        hintText: l10n.passwordHint,
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        primaryColor: primaryColor,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return l10n.passwordHintError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: createColoredInputDecoration(
                        labelText: l10n.confirmPasswordLabel,
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        primaryColor: primaryColor,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightController,
                      decoration: createColoredInputDecoration(
                        labelText: l10n.weightLabel,
                        hintText: l10n.weightHint,
                        prefixIcon: Icon(Icons.fitness_center, color: primaryColor),
                        primaryColor: primaryColor,
                      ),
                      keyboardType: TextInputType.number,
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
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(l10n.createAccountButton),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.alreadyHaveAccount),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
