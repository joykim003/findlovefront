// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/data/services/notification_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:frontend/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:frontend/presentation/pages/home/home_page.dart';
import 'package:frontend/presentation/pages/auth/login_screen.dart';
import 'package:frontend/presentation/pages/auth/register_screen.dart';
import 'package:frontend/presentation/pages/matches/matches_page.dart';
import 'package:frontend/presentation/pages/profile/profile_page.dart';
import 'package:frontend/presentation/pages/settings/settings_page.dart';
import 'package:frontend/presentation/pages/settings/notifications_page.dart';
import 'package:frontend/presentation/pages/settings/change_password_page.dart';
import 'package:frontend/presentation/pages/settings/terms_page.dart';
import 'package:frontend/presentation/pages/settings/privacy_policy_page.dart';
import 'package:frontend/shared/theme/app_theme.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/settings_provider.dart';
import 'package:frontend/presentation/pages/messages/conversations_page.dart';
import 'package:frontend/presentation/pages/messages/chat_page.dart';
import 'package:frontend/shared/utils/timeago_fr.dart';
import 'package:frontend/presentation/pages/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyC11XZZ3_qwL22YhwZNNDpr2n0QeiRUrNk',
          appId: '1:649409676103:web:45e4167c947a17cd08c262',
          messagingSenderId: '649409676103',
          projectId: 'findlove-b8a98',
          authDomain: 'findlove-b8a98.firebaseapp.com',
          storageBucket: 'findlove-b8a98.firebasestorage.app',
          measurementId: 'G-BP6YS08R59',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // Initialiser le service de notification
    final notificationService = NotificationService();
    await notificationService.initialize();
  } catch (e, stack) {
    debugPrint('Erreur lors de l\'initialisation de Firebase: $e');
    debugPrint('Stack trace: $stack');
  }

  final prefs = await SharedPreferences.getInstance();

  // Initialiser les traductions françaises de timeago
  initializeTimeagoFr();

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith((ref) => SettingsNotifier(prefs)),
        settingsNotifierProvider.overrideWithValue(SettingsNotifier(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.watch(settingsNotifierProvider);

    // Forcer la reconstruction de l'application lorsque le thème change
    final themeMode = settingsNotifier.themeMode;

    return MaterialApp.router(
      title: 'FindLove',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const SplashScreen(),
          ),
          ShellRoute(
            builder: (context, state, child) {
              return ScaffoldWithNavBar(child: child);
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: '/matches',
                builder: (context, state) => const MatchesPage(),
              ),
              GoRoute(
                path: '/messages',
                builder: (context, state) => const ConversationsPage(),
              ),
              GoRoute(
                path: '/messages/:conversationId',
                builder: (context, state) => ChatPage(
                  conversationId:
                      int.parse(state.pathParameters['conversationId']!),
                ),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/settings/notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/settings/change-password',
            builder: (context, state) => const ChangePasswordPage(),
          ),
          GoRoute(
            path: '/settings/terms',
            builder: (context, state) => const TermsPage(),
          ),
          GoRoute(
            path: '/settings/privacy',
            builder: (context, state) => const PrivacyPolicyPage(),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
        redirect: (context, state) {
          // Si l'état d'authentification est en cours de chargement, afficher un écran de chargement
          if (authState.isLoading) {
            return '/splash';
          }

          final isAuthenticated = authState.when(
            data: (user) => user.isAuthenticated ?? false,
            loading: () => false,
            error: (_, __) => false,
          );

          final isAuthRoute = state.matchedLocation == '/login' ||
              state.matchedLocation == '/register';

          final isOnboardingRoute = state.matchedLocation == '/onboarding';

          if (!isAuthenticated && !isAuthRoute && !isOnboardingRoute) {
            return '/onboarding';
          }

          if (isAuthenticated && (isAuthRoute || isOnboardingRoute)) {
            return '/';
          }

          return null;
        },
        errorBuilder: (context, state) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Page non trouvée'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(authStateProvider.notifier).logout(),
                child: const Text('Se déconnecter'),
              ),
            ],
          ),
        ),
      ),
      data: (user) => Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/matches');
                break;
              case 2:
                context.go('/messages');
                break;
              case 3:
                context.go('/profile');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          },
          selectedIndex: _calculateSelectedIndex(context),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Découvrir',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Matches',
            ),
            NavigationDestination(
              icon: Icon(Icons.message_outlined),
              selectedIcon: Icon(Icons.message),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Paramètres',
            ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String path = GoRouterState.of(context).uri.path;
    if (path.startsWith('/matches')) return 1;
    if (path.startsWith('/messages')) return 2;
    if (path.startsWith('/profile')) return 3;
    if (path.startsWith('/settings')) return 4;
    return 0;
  }
}
