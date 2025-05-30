import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/widgets/bottom_nav_bar.dart';
import 'package:frontend/presentation/widgets/custom_app_bar.dart';
import 'package:frontend/presentation/widgets/icon_action_button.dart';
import 'package:frontend/presentation/widgets/swipeable_card.dart';
import 'package:frontend/shared/theme/app_theme.dart';
import 'package:frontend/data/models/user_profile.dart';
import 'package:frontend/data/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<SwipeableCardState> _swipeableCardKey = GlobalKey<SwipeableCardState>();
  final ApiService _apiService = ApiService();
  List<UserProfile> _profiles = [];
  int _currentProfileIndex = 0;
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

  Future<void> _handleLike() async {
    if (_currentProfileIndex >= _profiles.length) return;

    final currentProfile = _profiles[_currentProfileIndex];
    try {
      final result = await _apiService.likeProfile(currentProfile.id);
      debugPrint('Like result: $result');
      
      // Si c'est un match, on pourrait afficher une notification
      if (result['message'] == "C'est un match !") {
        // TODO: Afficher une notification de match
      }

      setState(() {
        _currentProfileIndex++;
      });
    } catch (e) {
      debugPrint('Erreur lors du like: $e');
    }
  }

  Future<void> _handlePass() async {
    if (_currentProfileIndex >= _profiles.length) return;

    final currentProfile = _profiles[_currentProfileIndex];
    try {
      await _apiService.passProfile(currentProfile.id);
      setState(() {
        _currentProfileIndex++;
      });
    } catch (e) {
      debugPrint('Erreur lors du pass: $e');
    }
  }

  Future<void> _handleSuperLike() async {
    if (_currentProfileIndex >= _profiles.length) return;

    final currentProfile = _profiles[_currentProfileIndex];
    try {
      final result = await _apiService.superLikeProfile(currentProfile.id);
      debugPrint('Super like result: $result');
      
      // Si c'est un match, on pourrait afficher une notification
      if (result['message'] == "C'est un match !") {
        // TODO: Afficher une notification de match
      }

      setState(() {
        _currentProfileIndex++;
      });
    } catch (e) {
      debugPrint('Erreur lors du super like: $e');
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              context.go('/matches');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
      ),
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

    if (_currentProfileIndex >= _profiles.length) {
      return const Center(
        child: Text('Plus de profils disponibles pour le moment !'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SwipeableCard(
              key: _swipeableCardKey,
              user: _profiles[_currentProfileIndex],
              onSwipedLeft: _handlePass,
              onSwipedRight: _handleLike,
              onSwipedUp: _handleSuperLike,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconActionButton(
                icon: Icons.close,
                color: AppTheme.errorColor,
                onPressed: () => _swipeableCardKey.currentState?.swipeLeft(),
              ),
              IconActionButton(
                icon: Icons.star,
                color: AppTheme.accentColor,
                size: 60,
                onPressed: () => _swipeableCardKey.currentState?.swipeUp(),
              ),
              IconActionButton(
                icon: Icons.favorite,
                color: AppTheme.successColor,
                onPressed: () => _swipeableCardKey.currentState?.swipeRight(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
