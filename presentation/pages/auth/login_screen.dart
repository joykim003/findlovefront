// lib/presentation/pages/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/shared/widgets/custom_text_field.dart'; // Importez le CustomTextField

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Ajouter les contrôleurs pour les champs email et mot de passe
    // final _emailController = TextEditingController();
    // final _passwordController = TextEditingController();

    // TODO: Ajouter la logique de validation et de connexion
    // void _login() {
    //   if (_formKey.currentState!.validate()) {
    //     // Appeler le AuthService
    //     // Gérer le loading state
    //     // Naviguer si succès
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Se connecter'),
        // Optionnel: masquer le bouton retour si nécessaire
        // automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bienvenue de retour !',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Remplacé par CustomTextField
                CustomTextField(
                  // controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  // TODO: Ajouter la validation
                ),
                const SizedBox(height: 16),

                // Remplacé par CustomTextField
                CustomTextField(
                  // controller: _passwordController,
                  labelText: 'Mot de passe',
                  obscureText: true,
                  // TODO: Ajouter la validation
                ),
                const SizedBox(height: 24),

                // TODO: Remplacer par PrimaryButton avec loading state
                ElevatedButton(
                  onPressed: () {
                    // TODO: Appeler la fonction _login()
                    print('Login button pressed');
                    // Exemple de navigation après succès (temporaire)
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                     minimumSize: const Size(double.infinity, 50),
                     shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                     ),
                  ),
                  child: const Text('Se connecter'),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    // TODO: Naviguer vers l'écran "Mot de passe oublié"
                    print('Forgot Password pressed');
                    // Exemple de navigation (temporaire)
                    // context.push('/forgot-password');
                  },
                  child: const Text('Mot de passe oublié ?'),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Ou se connecter avec',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Boutons de connexion sociale
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // TODO: Remplacer par IconActionButton personnalisé ou GradientButton pour Google
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implémenter connexion Google
                        print('Google login pressed');
                      },
                       icon: Image.asset('assets/icons/google_logo.png', height: 24), // TODO: Ajoutez logos
                      label: const Text('Google'),
                       style: ElevatedButton.styleFrom(
                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                         shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                         ),
                       ),
                    ),
                    // TODO: Remplacer par IconActionButton personnalisé ou GradientButton pour Facebook
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implémenter connexion Facebook
                        print('Facebook login pressed');
                      },
                      icon: Image.asset('assets/icons/facebook_logo.png', height: 24), // TODO: Ajoutez logos
                      label: const Text('Facebook'),
                       style: ElevatedButton.styleFrom(
                         foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), backgroundColor: Colors.blue[700],
                         shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                         ),
                       ),
                    ),
                    // Ajoutez d'autres options (Apple, etc.)
                  ],
                ),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pas encore de compte ?"),
                    TextButton(
                      onPressed: () {
                        // Naviguer vers l'écran d'inscription
                        context.go('/register');
                      },
                      child: const Text("S'inscrire"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}