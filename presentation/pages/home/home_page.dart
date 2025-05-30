import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/widgets/custom_app_bar.dart';
import 'package:frontend/presentation/widgets/icon_action_button.dart';
import 'package:frontend/shared/theme/app_theme.dart';
import 'package:frontend/data/models/user_profile.dart';
import 'package:frontend/data/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<UserProfile> _profiles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final profiles = await _apiService.getProfiles();
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Découvrir',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppTheme.textPrimaryColor),
            onPressed: null,
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
              onPressed: _loadProfiles,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_profiles.isEmpty) {
      return const Center(
        child: Text('Plus de profils disponibles pour le moment !'),
      );
    }

    return ListView.builder(
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              if (profile.photos.isNotEmpty)
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    profile.photos[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, size: 50),
                      );
                    },
          ),
        ),
        Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.name}, ${profile.age}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (profile.location != null)
                      Text(
                        profile.location!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      profile.bio,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    if (profile.interests.isNotEmpty) ...[
                      const Text(
                        'Intérêts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: profile.interests.map((interest) {
                          return Chip(
                            label: Text(interest),
                            backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconActionButton(
                icon: Icons.close,
                color: AppTheme.errorColor,
                          onPressed: () => _handlePass(profile.id),
              ),
              IconActionButton(
                icon: Icons.star,
                color: AppTheme.accentColor,
                size: 60,
                          onPressed: () => _handleSuperLike(profile.id),
              ),
              IconActionButton(
                icon: Icons.favorite,
                color: AppTheme.successColor,
                          onPressed: () => _handleLike(profile.id),
                        ),
                      ],
              ),
            ],
          ),
        ),
      ],
          ),
        );
      },
    );
  }

  Future<void> _handleLike(int profileId) async {
    try {
      final result = await _apiService.likeProfile(profileId);
      if (result['message'] == "C'est un match !") {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("C'est un match !")),
          );
        }
      }
      _removeProfile(profileId);
    } catch (e) {
      debugPrint('Erreur lors du like: $e');
    }
  }

  Future<void> _handlePass(int profileId) async {
    try {
      await _apiService.passProfile(profileId);
      _removeProfile(profileId);
    } catch (e) {
      debugPrint('Erreur lors du pass: $e');
    }
  }

  Future<void> _handleSuperLike(int profileId) async {
    try {
      final result = await _apiService.superLikeProfile(profileId);
      if (result['message'] == "C'est un match !") {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("C'est un match !")),
          );
        }
      }
      _removeProfile(profileId);
    } catch (e) {
      debugPrint('Erreur lors du super like: $e');
    }
  }

  void _removeProfile(int profileId) {
    setState(() {
      _profiles.removeWhere((profile) => profile.id == profileId);
    });
  }
}
