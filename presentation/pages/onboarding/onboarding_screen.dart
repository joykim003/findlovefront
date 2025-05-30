// lib/presentation/pages/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Importez l'indicateur

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<Widget> _onboardingPages = [
    // TODO: Créez des widgets pour chaque page d'onboarding
    const OnboardingPage(
      imagePath: 'assets/images/onboarding1.png', // Remplacez par votre image
      title: 'Bienvenue sur MatchApp!',
      description: 'Trouvez votre partenaire idéal grâce à notre algorithme avancé.',
    ),
    const OnboardingPage(
      imagePath: 'assets/images/onboarding2.png', // Remplacez par votre image
      title: 'Swipez, Matchez, Chatez',
      description: "Explorez des profils, swipez vers la droite si vous aimez, et commencez à discuter si c'est réciproque.",
    ),
    const OnboardingPage(
      imagePath: 'assets/images/onboarding3.png', // Remplacez par votre image
      title: 'Votre Sécurité, Notre Priorité',
      description: 'Nous mettons tout en œuvre pour garantir un environnement sûr et respectueux pour tous nos utilisateurs.',
    ),
     const OnboardingPage(
      imagePath: 'assets/images/onboarding4.png', // Remplacez par votre image
      title: 'Prêt à Commencer ?',
      description: "Créez votre profil dès maintenant et lancez-vous dans l'aventure!",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            itemBuilder: (context, index) {
              return _onboardingPages[index];
            },
          ),
          Align(
            alignment: const Alignment(0, 0.85), // Positionnez l'indicateur
            child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 SmoothPageIndicator(
                   controller: _pageController,
                   count: _onboardingPages.length,
                   effect: const ExpandingDotsEffect( // Ou un autre effet de votre choix
                     activeDotColor: Colors.pink, // Utilisez votre couleur primaire
                     dotColor: Colors.grey,
                     dotHeight: 8,
                     dotWidth: 8,
                     spacing: 8,
                   ),
                 ),
                 const SizedBox(height: 40),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                   child: ElevatedButton( // TODO: Remplacez par votre PrimaryButton personnalisé
                      onPressed: () {
                         // Naviguer vers l'écran d'inscription ou de connexion
                         context.go('/login'); // Ou '/register' si vous préférez
                      },
                      style: ElevatedButton.styleFrom(
                         minimumSize: Size(double.infinity, 50), // Bouton pleine largeur
                         shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25), // Rayon arrondi
                         ),
                      ),
                      child: const Text('Commencer'),
                   ),
                 ),
               ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour une seule page d'onboarding
class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset( // TODO: Assurez-vous d'avoir des images dans vos assets et configurez pubspec.yaml
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120), // Espace pour l'indicateur et le bouton
        ],
      ),
    );
  }
}