import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/settings_provider.dart';
import 'package:frontend/data/services/api_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;

  Future<void> _logout() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await ref.read(authStateProvider.notifier).logout();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Déconnexion réussie')),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la déconnexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et supprimera toutes vos données, y compris vos photos, matches et messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await _apiService.post('/auth/delete-account', body: {});
      await ref.read(authStateProvider.notifier).logout();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte supprimé avec succès')),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression du compte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _logout,
                child: const Text('Se déconnecter'),
              ),
            ],
          ),
        ),
        data: (user) => _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _buildSection(
                    title: 'Compte',
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Profil'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email'),
                        subtitle: Text(user.email ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifications'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings/notifications'),
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Préférences',
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language_outlined),
                        title: const Text('Langue'),
                        trailing: Text(ref.watch(settingsProvider).language ==
                                AppLanguage.french
                            ? 'Français'
                            : 'English'),
                        onTap: () async {
                          final language = await showDialog<AppLanguage>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Choisir la langue'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('Français'),
                                    onTap: () => Navigator.pop(
                                        context, AppLanguage.french),
                                  ),
                                  ListTile(
                                    title: const Text('English'),
                                    onTap: () => Navigator.pop(
                                        context, AppLanguage.english),
                                  ),
                                ],
                              ),
                            ),
                          );
                          if (language != null) {
                            await ref
                                .read(settingsNotifierProvider)
                                .setLanguage(language);
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.dark_mode_outlined),
                        title: const Text('Thème'),
                        trailing: Text(
                          switch (ref.watch(settingsProvider).themeMode) {
                            AppThemeMode.system => 'Système',
                            AppThemeMode.light => 'Clair',
                            AppThemeMode.dark => 'Sombre',
                          },
                        ),
                        onTap: () async {
                          final theme = await showDialog<AppThemeMode>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Choisir le thème'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text('Système'),
                                    onTap: () => Navigator.pop(
                                        context, AppThemeMode.system),
                                  ),
                                  ListTile(
                                    title: const Text('Clair'),
                                    onTap: () => Navigator.pop(
                                        context, AppThemeMode.light),
                                  ),
                                  ListTile(
                                    title: const Text('Sombre'),
                                    onTap: () => Navigator.pop(
                                        context, AppThemeMode.dark),
                                  ),
                                ],
                              ),
                            ),
                          );
                          if (theme != null) {
                            await ref
                                .read(settingsNotifierProvider)
                                .setThemeMode(theme);
                          }
                        },
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'Sécurité',
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Changer le mot de passe'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings/change-password'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Supprimer le compte'),
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: _deleteAccount,
                      ),
                    ],
                  ),
                  _buildSection(
                    title: 'À propos',
                    children: [
                      const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('Version'),
                        trailing: Text('1.0.0'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text('Conditions d\'utilisation'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings/terms'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('Politique de confidentialité'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings/privacy'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Se déconnecter'),
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
