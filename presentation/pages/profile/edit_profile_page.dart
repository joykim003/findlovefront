import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/services/api_service.dart';
import '../../widgets/interests_section.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserProfile profile;

  const EditProfilePage({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;
  String? _error;

  // Contrôleurs pour les champs de texte
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;

  // Valeurs sélectionnées
  late String _selectedGender;
  late String _selectedOrientation;
  late List<String> _interests;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs existantes
    _nameController = TextEditingController(text: widget.profile.name);
    _ageController = TextEditingController(text: widget.profile.age.toString());
    _bioController = TextEditingController(text: widget.profile.bio);
    _locationController = TextEditingController(text: widget.profile.location ?? '');
    
    // Initialiser les valeurs sélectionnées
    _selectedGender = widget.profile.gender;
    _selectedOrientation = widget.profile.orientation;
    _interests = List.from(widget.profile.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final updatedProfile = await _apiService.updateProfile(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        orientation: _selectedOrientation,
        bio: _bioController.text,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        interests: _interests,
      );

      if (mounted) {
        Navigator.pop(context, updatedProfile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès !')),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // Nom
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        hintText: 'Votre nom',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Âge
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Âge',
                        hintText: 'Votre âge',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre âge';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 18) {
                          return 'Vous devez avoir au moins 18 ans';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Genre
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Genre',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'M', child: Text('Masculin')),
                        DropdownMenuItem(value: 'F', child: Text('Féminin')),
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

                    // Orientation
                    DropdownButtonFormField<String>(
                      value: _selectedOrientation,
                      decoration: const InputDecoration(
                        labelText: 'Orientation',
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
                    const SizedBox(height: 16),

                    // Localisation
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Localisation',
                        hintText: 'Votre ville',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bio
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        hintText: 'Parlez-nous de vous...',
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une bio';
                        }
                        if (value.length < 10) {
                          return 'La bio doit contenir au moins 10 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Intérêts
                    const Text(
                      'Intérêts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InterestsSection(
                      interests: _interests,
                      onInterestsUpdated: (newInterests) {
                        setState(() {
                          _interests = newInterests;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    // Bouton de sauvegarde
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Enregistrer les modifications'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 