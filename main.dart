// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/pages/home/home_screen.dart';
import 'package:myapp/presentation/pages/splash/splash_screen.dart';
import 'package:myapp/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:myapp/presentation/pages/home/home_page.dart';
import 'package:myapp/presentation/pages/auth/login_screen.dart';
import 'package:myapp/presentation/pages/auth/register_screen.dart'; // Importez le nouvel écran
import 'package:myapp/shared/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  get sync => null;

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
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
          path: '/register', // Ajoutez la route pour l'inscription
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        // Ajoutez d'autres routes ici plus tard
      ],
      // Optionnel: Redirect
    );

    return MaterialApp.router(
      title: 'MatchApp',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}