// lib/presentation/pages/auth/register_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/widgets/custom_text_field.dart'; // Importez le CustomTextField
import 'package:frontend/shared/widgets/photo_uploader.dart';
import 'package:frontend/shared/widgets/interests_selector.dart';
import 'package:frontend/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedGender = 'M';
  String _selectedOrientation = 'H';
  List<String> _interests = [];
  List<File> _photos = [];
  bool _isLoading = false;
  String? _error;
  int _currentStep = 0;

  final List<String> _steps = [
    'Informations de Connexion',
    'Informations de Base',
    'Photos de Profil',
    'Localisation',
    'Intérêts',
    'Biographie',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_photos.isEmpty) {
      setState(() {
        _error = 'Veuillez ajouter au moins une photo';
      });
      setState(() {
        _currentStep = 2; // Retour à l'étape des photos
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(authStateProvider.notifier).register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        orientation: _selectedOrientation,
        bio: _bioController.text.trim(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        interests: _interests,
        photos: _photos,
      );
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _register();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.go('/login');
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildLoginInfoStep();
      case 1:
        return _buildBasicInfoStep();
      case 2:
        return _buildPhotoUploadStep();
      case 3:
        return _buildLocationStep();
      case 4:
        return _buildInterestsStep();
      case 5:
        return _buildBioStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoginInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: _emailController,
           labelText: 'Email',
           keyboardType: TextInputType.emailAddress,
           validator: (value) {
              if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre email';
              }
            if (!value.contains('@')) {
              return 'Veuillez entrer un email valide';
            }
              return null;
           },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
           labelText: 'Mot de passe',
           obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
              return 'Veuillez entrer un mot de passe';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
           },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'Confirmer le mot de passe',
           obscureText: true,
             validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'Veuillez confirmer votre mot de passe';
               }
            if (value != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
               return null;
            },
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         CustomTextField(
          controller: _nameController,
            labelText: 'Nom',
              validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre nom';
               }
               return null;
            },
         ),
         const SizedBox(height: 16),
          CustomTextField(
          controller: _ageController,
            labelText: 'Âge',
            keyboardType: TextInputType.number,
             validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre âge';
               }
               final age = int.tryParse(value);
            if (age == null || age < 18 || age > 100) {
              return 'Veuillez entrer un âge valide (18-100)';
               }
               return null;
            },
         ),
         const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Genre',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'M', child: Text('Homme')),
            DropdownMenuItem(value: 'F', child: Text('Femme')),
            DropdownMenuItem(value: 'O', child: Text('Autre')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGender = value;
              });
            }
          },
         ),
         const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedOrientation,
          decoration: const InputDecoration(
            labelText: 'Orientation',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'H', child: Text('Hétérosexuel')),
            DropdownMenuItem(value: 'G', child: Text('Homosexuel')),
            DropdownMenuItem(value: 'B', child: Text('Bisexuel')),
            DropdownMenuItem(value: 'O', child: Text('Autre')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedOrientation = value;
              });
            }
          },
         ),
      ],
    );
  }

  Widget _buildPhotoUploadStep() {
    return PhotoUploader(
      photos: _photos,
      onPhotosChanged: (photos) {
        setState(() {
          _photos = photos;
        });
      },
    );
  }

   Widget _buildLocationStep() {
    return CustomTextField(
      controller: _locationController,
      labelText: 'Ville',
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 2) {
          return 'Veuillez entrer une ville valide';
        }
        return null;
      },
     );
   }

    Widget _buildInterestsStep() {
    return InterestsSelector(
      selectedInterests: _interests,
      onInterestsChanged: (interests) {
        setState(() {
          _interests = interests;
        });
      },
      );
    }

    Widget _buildBioStep() {
    return CustomTextField(
      controller: _bioController,
      labelText: 'Biographie',
      maxLines: 5,
               validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer une biographie';
        }
        if (value.length < 10) {
          return 'La biographie doit contenir au moins 10 caractères';
                 }
                 return null;
              },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              Text(
                _steps[_currentStep],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            Expanded(
              child: SingleChildScrollView(
                  child: _buildStepContent(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _isLoading ? null : _previousStep,
                      child: const Text('Précédent'),
                    )
                  else
                    const SizedBox.shrink(),
            ElevatedButton(
                    onPressed: _isLoading ? null : _nextStep,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_currentStep == _steps.length - 1 ? 'S\'inscrire' : 'Suivant'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
