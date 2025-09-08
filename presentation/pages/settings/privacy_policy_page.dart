import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politique de confidentialité'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Politique de confidentialité de FindLove',
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
              title: '1. Collecte des informations',
              content: 'Nous collectons les informations suivantes :\n\n'
                  '• Informations de profil (nom, âge, genre, orientation, bio, photos)\n'
                  '• Informations de compte (email, mot de passe)\n'
                  '• Données de localisation (si vous choisissez de les partager)\n'
                  '• Données d\'utilisation (matches, likes, messages)\n'
                  '• Informations techniques (adresse IP, type d\'appareil, système d\'exploitation)',
            ),
            _buildSection(
              context,
              title: '2. Utilisation des informations',
              content: 'Nous utilisons vos informations pour :\n\n'
                  '• Fournir et améliorer nos services\n'
                  '• Personnaliser votre expérience\n'
                  '• Vous mettre en relation avec d\'autres utilisateurs\n'
                  '• Assurer la sécurité de la plateforme\n'
                  '• Communiquer avec vous concernant votre compte',
            ),
            _buildSection(
              context,
              title: '3. Partage des informations',
              content: 'Nous ne vendons pas vos données personnelles. Nous partageons vos informations :\n\n'
                  '• Avec les utilisateurs que vous avez matchés\n'
                  '• Avec nos prestataires de services (hébergement, analyse)\n'
                  '• Lorsque requis par la loi\n'
                  '• Pour protéger nos droits ou la sécurité des utilisateurs',
            ),
            _buildSection(
              context,
              title: '4. Protection des données',
              content: 'Nous mettons en œuvre des mesures de sécurité pour protéger vos informations :\n\n'
                  '• Chiffrement des données sensibles\n'
                  '• Accès restreint aux données personnelles\n'
                  '• Surveillance régulière de nos systèmes\n'
                  '• Formation de notre personnel à la sécurité',
            ),
            _buildSection(
              context,
              title: '5. Vos droits',
              content: 'Vous avez le droit de :\n\n'
                  '• Accéder à vos données personnelles\n'
                  '• Corriger vos informations\n'
                  '• Supprimer votre compte et vos données\n'
                  '• Vous opposer au traitement de vos données\n'
                  '• Exporter vos données',
            ),
            _buildSection(
              context,
              title: '6. Cookies et technologies similaires',
              content: 'Nous utilisons des cookies et des technologies similaires pour :\n\n'
                  '• Maintenir votre session\n'
                  '• Analyser l\'utilisation de l\'application\n'
                  '• Personnaliser votre expérience\n'
                  '• Améliorer nos services',
            ),
            _buildSection(
              context,
              title: '7. Conservation des données',
              content: 'Nous conservons vos données :\n\n'
                  '• Tant que votre compte est actif\n'
                  '• Jusqu\'à ce que vous demandiez leur suppression\n'
                  '• Selon les exigences légales\n'
                  '• Pour des raisons de sécurité',
            ),
            _buildSection(
              context,
              title: '8. Modifications',
              content: 'Nous pouvons mettre à jour cette politique de confidentialité. '
                  'Nous vous informerons de tout changement important via l\'application '
                  'ou par email.',
            ),
            _buildSection(
              context,
              title: '9. Contact',
              content: 'Pour toute question concernant cette politique de confidentialité '
                  'ou vos données personnelles, contactez-nous à :\n\n'
                  'Email : privacy@findlove.com\n'
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