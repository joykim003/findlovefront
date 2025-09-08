import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
// Provider pour gérer l'état des notifications
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationSettings>((ref) {
  return NotificationsNotifier();
});

class NotificationSettings {
  final bool newMatches;
  final bool messages;
  final bool likes;
  final bool superLikes;
  final bool profileViews;
  final bool emailNotifications;

  NotificationSettings({
    this.newMatches = true,
    this.messages = true,
    this.likes = true,
    this.superLikes = true,
    this.profileViews = true,
    this.emailNotifications = true,
  });

  NotificationSettings copyWith({
    bool? newMatches,
    bool? messages,
    bool? likes,
    bool? superLikes,
    bool? profileViews,
    bool? emailNotifications,
  }) {
    return NotificationSettings(
      newMatches: newMatches ?? this.newMatches,
      messages: messages ?? this.messages,
      likes: likes ?? this.likes,
      superLikes: superLikes ?? this.superLikes,
      profileViews: profileViews ?? this.profileViews,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }

  Map<String, dynamic> toJson() => {
    'newMatches': newMatches,
    'messages': messages,
    'likes': likes,
    'superLikes': superLikes,
    'profileViews': profileViews,
    'emailNotifications': emailNotifications,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      newMatches: json['newMatches'] ?? true,
      messages: json['messages'] ?? true,
      likes: json['likes'] ?? true,
      superLikes: json['superLikes'] ?? true,
      profileViews: json['profileViews'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationSettings> {
  static const _prefsKey = 'notification_settings';
  
  NotificationsNotifier() : super(NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null) {
      try {
        final json = Map<String, dynamic>.from(
          jsonString.split(',').asMap().map((key, value) {
            final parts = value.split(':');
            return MapEntry(parts[0], parts[1] == 'true');
          }),
        );
        state = NotificationSettings.fromJson(json);
      } catch (e) {
        print('Erreur lors du chargement des paramètres de notification: $e');
      }
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final json = state.toJson();
    final jsonString = json.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    await prefs.setString(_prefsKey, jsonString);
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    state = newSettings;
    await _saveSettings();
  }

  Future<void> toggleNewMatches(bool value) async {
    state = state.copyWith(newMatches: value);
    await _saveSettings();
  }

  Future<void> toggleMessages(bool value) async {
    state = state.copyWith(messages: value);
    await _saveSettings();
  }

  Future<void> toggleLikes(bool value) async {
    state = state.copyWith(likes: value);
    await _saveSettings();
  }

  Future<void> toggleSuperLikes(bool value) async {
    state = state.copyWith(superLikes: value);
    await _saveSettings();
  }

  Future<void> toggleProfileViews(bool value) async {
    state = state.copyWith(profileViews: value);
    await _saveSettings();
  }

  Future<void> toggleEmailNotifications(bool value) async {
    state = state.copyWith(emailNotifications: value);
    await _saveSettings();
  }
}

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Notifications dans l\'application',
            children: [
              SwitchListTile(
                title: const Text('Nouveaux matches'),
                subtitle: const Text('Soyez notifié quand vous avez un nouveau match'),
                value: settings.newMatches,
                onChanged: (value) => ref
                    .read(notificationsProvider.notifier)
                    .toggleNewMatches(value),
              ),
              SwitchListTile(
                title: const Text('Messages'),
                subtitle: const Text('Soyez notifié quand vous recevez un nouveau message'),
                value: settings.messages,
                onChanged: (value) => ref
                    .read(notificationsProvider.notifier)
                    .toggleMessages(value),
              ),
              SwitchListTile(
                title: const Text('Likes'),
                subtitle: const Text('Soyez notifié quand quelqu\'un vous like'),
                value: settings.likes,
                onChanged: (value) => ref
                    .read(notificationsProvider.notifier)
                    .toggleLikes(value),
              ),
              SwitchListTile(
                title: const Text('Super Likes'),
                subtitle: const Text('Soyez notifié quand quelqu\'un vous super like'),
                value: settings.superLikes,
                onChanged: (value) => ref
                    .read(notificationsProvider.notifier)
                    .toggleSuperLikes(value),
              ),
              SwitchListTile(
                title: const Text('Vues de profil'),
                subtitle: const Text('Soyez notifié quand quelqu\'un consulte votre profil'),
                value: settings.profileViews,
                onChanged: (value) => ref
                    .read(notificationsProvider.notifier)
                    .toggleProfileViews(value),
              ),
            ],
          ),
          const Divider(),
          _buildSection(
            context,
            title: 'Notifications par email',
            children: [
              SwitchListTile(
                title: const Text('Notifications par email'),
                subtitle: const Text('Recevez des notifications par email'),
                value: settings.emailNotifications,
                onChanged: (value) => ref
                    .read(notificationsProvider.notifier)
                    .toggleEmailNotifications(value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
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
      ],
    );
  }
} 