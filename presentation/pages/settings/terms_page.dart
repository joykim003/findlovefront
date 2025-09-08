import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions d\'utilisation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conditions d\'utilisation de FindLove',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Dernière mise à jour : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: '1. Acceptation des conditions',
              content: 'En utilisant FindLove, vous acceptez d\'être lié par ces conditions d\'utilisation. '
                  'Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser l\'application.',
            ),
            _buildSection(
              context,
              title: '2. Éligibilité',
              content: 'Vous devez être âgé d\'au moins 18 ans pour utiliser FindLove. '
                  'En utilisant l\'application, vous déclarez et garantissez que vous avez au moins 18 ans.',
            ),
            _buildSection(
              context,
              title: '3. Compte utilisateur',
              content: 'Vous êtes responsable de maintenir la confidentialité de votre compte et de votre mot de passe. '
                  'Vous acceptez d\'être responsable de toutes les activités qui se produisent sous votre compte.',
            ),
            _buildSection(
              context,
              title: '4. Comportement des utilisateurs',
              content: 'Vous acceptez de ne pas :\n\n'
                  '• Publier de contenu illégal, offensant ou inapproprié\n'
                  '• Harceler ou intimider d\'autres utilisateurs\n'
                  '• Utiliser l\'application à des fins malveillantes\n'
                  '• Violer les droits d\'autrui',
            ),
            _buildSection(
              context,
              title: '5. Propriété intellectuelle',
              content: 'FindLove et son contenu sont protégés par les droits d\'auteur et autres lois sur la propriété intellectuelle. '
                  'Vous conservez vos droits sur le contenu que vous publiez.',
            ),
            _buildSection(
              context,
              title: '6. Confidentialité',
              content: 'Votre utilisation de FindLove est également soumise à notre Politique de confidentialité, '
                  'qui décrit comment nous collectons, utilisons et protégeons vos informations.',
            ),
            _buildSection(
              context,
              title: '7. Modifications',
              content: 'Nous nous réservons le droit de modifier ces conditions à tout moment. '
                  'Les modifications prendront effet dès leur publication dans l\'application.',
            ),
            _buildSection(
              context,
              title: '8. Résiliation',
              content: 'Nous pouvons suspendre ou résilier votre compte si vous violez ces conditions '
                  'ou pour toute autre raison à notre seule discrétion.',
            ),
            _buildSection(
              context,
              title: '9. Limitation de responsabilité',
              content: 'FindLove est fourni "tel quel". Nous ne garantissons pas que l\'application '
                  'sera ininterrompue ou exempte d\'erreurs.',
            ),
            _buildSection(
              context,
              title: '10. Contact',
              content: 'Pour toute question concernant ces conditions, contactez-nous à :\n\n'
                  'Email : terms@findlove.com\n'
                  'Adresse : 123 Rue de l\'Amour, 75000 Paris, France',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
} 