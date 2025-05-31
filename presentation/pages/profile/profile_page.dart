import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/services/api_service.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/interests_section.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String? _error;
  
  // Contrôleurs pour les champs de texte
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  
  final String _selectedGender = 'M';
  final String _selectedOrientation = 'H';
  final List<String> _interests = [];
  final List<String> _photos = [];
  UserProfile? _profile;
  
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final authState = ref.read(authStateProvider);
      final user = authState.when(
        data: (user) => user,
        loading: () => null,
        error: (_, __) => null,
      );

      if (user == null) {
        throw 'Utilisateur non connecté';
      }

      final profile = await _apiService.getProfile(user.id);
      
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onInterestsUpdated(List<String> newInterests) {
    setState(() {
      if (_profile != null) {
        _profile = _profile!.copyWith(interests: newInterests);
      }
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO: Implémenter l'endpoint pour sauvegarder le profil
      // Pour l'instant, on simule juste un délai
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès !')),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addPhoto() async {
    // TODO: Implémenter la sélection de photo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité d\'ajout de photo à venir !'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Erreur: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_profile == null) {
      return const Center(
        child: Text('Profil non trouvé'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos
          if (_profile!.photos.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _profile!.photos.length,
                itemBuilder: (context, index) {
                  final photoUrl = _profile!.photos[index];
                  if (photoUrl.isEmpty) return const SizedBox.shrink();
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        photoUrl,
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 24),

          // Informations de base
          Text(
            '${_profile!.name}, ${_profile!.age}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (_profile!.location?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Text(
              _profile!.location!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],

          const SizedBox(height: 24),

          // Bio
          if (_profile!.bio.isNotEmpty) ...[
            const Text(
              'À propos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(_profile!.bio),
            const SizedBox(height: 24),
          ],

          // Intérêts
          InterestsSection(
            interests: _profile!.interests,
            onInterestsUpdated: _onInterestsUpdated,
          ),

          const SizedBox(height: 24),

          // Bouton de modification
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implémenter la modification du profil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Modification du profil à venir !'),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Modifier mon profil'),
            ),
          ),
        ],
      ),
    );
  }
} 