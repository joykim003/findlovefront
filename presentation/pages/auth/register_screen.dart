// lib/presentation/pages/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/widgets/custom_text_field.dart'; // Importez le CustomTextField
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  int _currentStep = 0;
  // TODO: Stocker les données du formulaire ici ou dans un provider
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController = TextEditingController();
  // final TextEditingController _nameController = TextEditingController(); // Controller pour le nom
  // final TextEditingController _ageController = TextEditingController(); // Controller pour l'âge
  // TODO: Variables pour genre et orientation
  // TODO: Liste pour stocker les fichiers photos sélectionnés
  // TODO: Variable pour stocker la localisation (Latitude, Longitude ou adresse)
  // TODO: Liste pour stocker les intérêts sélectionnés
  // final TextEditingController _bioController = TextEditingController(); // Controller pour la bio


  // final _formKeyStep1 = GlobalKey<FormState>(); // Clé pour valider l'étape 1
  // final _formKeyStep2 = GlobalKey<FormState>(); // Clé pour valider l'étape 2
  // TODO: Clé pour valider l'étape 3
  // TODO: Clé pour valider l'étape 4
  // TODO: Clé pour valider l'étape 5
  // TODO: Clé pour valider l'étape 6


  // Liste des "étapes" du formulaire. Chaque étape sera un widget ou une fonction.
  final List<String> _steps = [
    'Informations de Connexion', // Email/Password
    'Informations de Base',     // Nom, âge, genre, orientation
    'Photos de Profil',         // Upload photos
    'Localisation',             // Géolocalisation
    'Intérêts',               // Sélection hobbies
    'Biographie',               // Description personnelle
  ];

  // Méthode pour construire le contenu de l'étape actuelle
  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildLoginInfoStep();
      case 1:
        return _buildBasicInfoStep();
      case 2:
        return _buildPhotoUploadStep();
      case 3:
        return _buildLocationStep();
      case 4:
        return _buildInterestsStep();
      case 5:
        return _buildBioStep();
      default:
        return Container(); // Should not happen
    }
  }

  // Widgets placeholder pour chaque étape
  Widget _buildLoginInfoStep() {
    // TODO: Ajouter une Form et GlobalKey pour la validation
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Étape 1: Informations de Connexion', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        CustomTextField(
           // controller: _emailController,
           labelText: 'Email',
           keyboardType: TextInputType.emailAddress,
           // TODO: Ajouter la validation pour l'email
           validator: (value) {
              if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre email';
              }
              // TODO: Ajouter une validation de format email plus robuste
              return null;
           },
        ),
        const SizedBox(height: 16),

        CustomTextField(
           // controller: _passwordController,
           labelText: 'Mot de passe',
           obscureText: true,
           // TODO: Ajouter la validation pour le mot de passe (longueur min, caractères spéciaux, etc.)
            validator: (value) {
              if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre mot de passe';
              }
              // TODO: Ajouter des règles de complexité
              return null;
           },
        ),
        const SizedBox(height: 16),

        CustomTextField(
           // controller: _confirmPasswordController,
           labelText: 'Confirmer mot de passe',
           obscureText: true,
            // TODO: Ajouter la validation pour confirmer le mot de passe (doit correspondre au mot de passe)
             validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'Veuillez confirmer votre mot de passe';
               }
               // TODO: Comparer avec le champ mot de passe
              // if (value != _passwordController.text) {
              //    return 'Les mots de passe ne correspondent pas';
              // }
               return null;
            },
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
     // TODO: Ajouter une Form et GlobalKey pour la validation
    return Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Étape 2: Informations de Base', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
         const SizedBox(height: 20),

         CustomTextField(
            // controller: _nameController,
            labelText: 'Nom',
             // TODO: Ajouter la validation
              validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre nom';
               }
               return null;
            },
         ),
         const SizedBox(height: 16),

          CustomTextField(
            // controller: _ageController,
            labelText: 'Âge',
            keyboardType: TextInputType.number,
             // TODO: Ajouter la validation (âge minimum, format numérique)
             validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'Veuillez entrer votre âge';
               }
               final age = int.tryParse(value);
               if (age == null || age < 18) { // Exemple: âge minimum 18
                 return 'Vous devez avoir au moins 18 ans';
               }
               return null;
            },
         ),
         const SizedBox(height: 16),

         Text('Genre', style: Theme.of(context).textTheme.titleMedium), // Titre pour la sélection de genre
         const SizedBox(height: 8),
         // TODO: Ajouter le widget pour la sélection de genre (ex: Radio buttons, Dropdown)
         Container(
           padding: const EdgeInsets.all(12.0),
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey),
             borderRadius: BorderRadius.circular(8.0),
           ),
           child: const Text('Sélection Genre - TODO'), // Placeholder
         ),
         const SizedBox(height: 16),

         Text('Orientation', style: Theme.of(context).textTheme.titleMedium), // Titre pour la sélection d'orientation
          const SizedBox(height: 8),
         // TODO: Ajouter le widget pour la sélection d'orientation (ex: Chips sélectionnables)
          Container(
           padding: const EdgeInsets.all(12.0),
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey),
             borderRadius: BorderRadius.circular(8.0),
           ),
           child: const Text('Sélection Orientation - TODO'), // Placeholder
         ),
      ],
    );
  }

  Widget _buildPhotoUploadStep() {
     // TODO: Implémenter l'upload de photos (max 6) avec drag&drop
    return Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Étape 3: Photos de Profil', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
         const SizedBox(height: 20),
         Text(
            'Chargez jusqu\'à 6 photos. La première photo sera votre photo principale.',
            style: Theme.of(context).textTheme.titleMedium,
         ),
         const SizedBox(height: 20),
         // TODO: Ajouter la grille pour afficher les photos et un bouton/zone pour en ajouter
         // TODO: Implémenter la logique de sélection et d'affichage des photos
         // TODO: Implémenter la logique de drag&drop pour réorganiser les photos
         Container(
           height: 200, // Hauteur indicative pour la zone d'upload
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey),
             borderRadius: BorderRadius.circular(8.0),
             color: Colors.grey[200],
           ),
           child: const Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                 SizedBox(height: 10),
                 Text('Appuyez pour ajouter des photos (max 6)'),
                 SizedBox(height: 10),
                  // TODO: Afficher les aperçus des photos chargées ici
                  Text('0/6 photos chargées'),
               ],
             ),
           ),
         ),
         // TODO: Ajouter la validation (au moins 1 photo requise, max 6)
      ],
    );
  }

   Widget _buildLocationStep() {
      // TODO: Implémenter la géolocalisation
     return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
         Text('Étape 4: Localisation', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(
             'Nous avons besoin de votre localisation pour vous montrer les utilisateurs proches.',
             style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          // TODO: Ajouter un bouton pour demander la permission de localisation
          ElevatedButton( // TODO: Remplacer par un bouton stylisé
             onPressed: () {
               // TODO: Implémenter la demande de permission de localisation
               print('Demander permission de localisation');
             },
             child: const Text('Activer la localisation'),
          ),
          const SizedBox(height: 20),
          // TODO: Afficher la localisation actuelle si obtenue, ou un message d'erreur
           Container(
           padding: const EdgeInsets.all(12.0),
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey),
             borderRadius: BorderRadius.circular(8.0),
           ),
           child: const Center(child: Text('Statut localisation: En attente... - TODO')), // Placeholder
         ),
          const SizedBox(height: 20),
          // TODO: Optionnel: Afficher une carte avec la position
          // Container(
          //   height: 200,
          //   color: Colors.grey[300],
          //   child: Center(child: Text('Carte - TODO')),
          // ),
         // TODO: Ajouter la validation (localisation requise)
       ],
     );
   }

    Widget _buildInterestsStep() {
      // TODO: Implémenter la sélection d'intérêts (chips) en utilisant TagSelector
      return Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Étape 5: Intérêts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
           Text(
              'Sélectionnez vos centres d\'intérêt pour nous aider à trouver des matchs compatibles.',
               style: Theme.of(context).textTheme.titleMedium,
           ),
           const SizedBox(height: 20),
           // TODO: Afficher les chips sélectionnables - Utiliser TagSelector ou similaire
           Container(
             padding: const EdgeInsets.all(12.0),
             decoration: BoxDecoration(
               border: Border.all(color: Colors.grey),
               borderRadius: BorderRadius.circular(8.0),
               color: Colors.grey[200],
             ),
             child: const Center(
               child: Text('Zone de sélection des intérêts (Chips) - TODO'), // Placeholder
             ),
           ),
           const SizedBox(height: 20),
            // TODO: Ajouter la validation (au moins un intérêt sélectionné ?)
        ],
      );
    }

    Widget _buildBioStep() {
       // TODO: Implémenter la bio (500 caractères max) en utilisant CustomTextField
      return Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Étape 6: Biographie', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
           Text(
              'Présentez-vous en quelques mots (500 caractères maximum).',
               style: Theme.of(context).textTheme.titleMedium,
           ),
           const SizedBox(height: 20),
           CustomTextField( // Utilisation de CustomTextField pour la bio
             // controller: _bioController,
             labelText: 'Parlez de vous',
             hintText: 'Décrivez vos passions, vos rêves...',
             maxLines: 5, // Permettre plusieurs lignes pour la bio
             maxLength: 500,
              // TODO: Ajouter validation si nécessaire (minimum de caractères ?)
               validator: (value) {
                 if (value != null && value.length > 500) {
                    return 'La biographie ne peut pas dépasser 500 caractères';
                 }
                 return null;
              },
           ),
        ],
      );
    }


  void _nextStep() {
     // TODO: Ajouter la validation de l'étape courante avant de passer à la suivante
     // Ex: if (_formKeyStep1.currentState!.validate()) { _currentStep++; }
     bool isValid = true; // Placeholder for validation check
     // TODO: Implement actual validation based on _currentStep and form keys
     if (_currentStep == 0) {
        // Validate step 1
        // if (_formKeyStep1.currentState!.validate()) {
        //   isValid = true;
        // } else {
        //   isValid = false;
        // }
     } else if (_currentStep == 1) {
        // Validate step 2
         // if (_formKeyStep2.currentState!.validate()) {
        //   isValid = true;
        // } else {
        //   isValid = false;
        // }
     } else if (_currentStep == 2) {
        // Validate step 3 (photo upload)
         // TODO: Check if at least one photo is uploaded and max 6
         print('Validating photo upload step...');
         isValid = true; // Placeholder
     } else if (_currentStep == 3) {
        // Validate step 4 (location)
         // TODO: Check if location permission is granted and location is obtained
         print('Validating location step...');
         isValid = true; // Placeholder
     } else if (_currentStep == 4) {
        // Validate step 5 (interests)
         // TODO: Check if at least one interest is selected
         print('Validating interests step...');
         isValid = true; // Placeholder
     } else if (_currentStep == 5) {
         // Validate step 6 (bio)
         // TODO: Check if bio meets criteria (e.g., minimum length)
         print('Validating bio step...');
         isValid = true; // Placeholder
     }
     // Add validation for other steps

    if (isValid) {
       if (_currentStep < _steps.length - 1) {
         setState(() {
           _currentStep++;
         });
       } else {
         // Dernière étape, déclencher l'inscription finale
         _completeRegistration();
       }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
       // Sur la première étape, on peut revenir à l'écran de connexion
       context.go('/login');
    }
  }

  void _completeRegistration() {
    // TODO: Récupérer toutes les données du formulaire (depuis les controllers ou le provider)
    // TODO: Appeler le AuthService pour l'inscription
    print('Inscription complète ! Données à envoyer au backend.');
    // TODO: Gérer le loading state
    // TODO: Naviguer vers l'écran de configuration du profil ou la page principale après succès
     // Exemple de navigation (temporaire)
     context.go('/profile-setup'); // TODO: Définir cette route
  }

  @override
  void dispose() {
    // TODO: Disposer les controllers si vous les utilisez comme champs d'état
    // _emailController.dispose();
    // _passwordController.dispose();
    // _confirmPasswordController.dispose();
    // _nameController.dispose();
    // _ageController.dispose();
    // _bioController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte (${_currentStep + 1}/${_steps.length})'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null, // Pas de bouton retour visuel sur la première étape
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indicateur de progression
             LinearProgressIndicator(
               value: (_currentStep + 1) / _steps.length,
               backgroundColor: Colors.grey[300],
               color: Theme.of(context).primaryColor, // Utiliser la couleur primaire du thème
             ),
             const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: _buildStepContent(_currentStep),
              ),
            ),

            const SizedBox(height: 30),

            // Bouton Suivant ou S'inscrire
            ElevatedButton(
              onPressed: _nextStep, // Utilisation du paramètre nommé onPressed
              style: ElevatedButton.styleFrom(
                 minimumSize: const Size(double.infinity, 50),
                 shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                 ),
                 backgroundColor: Theme.of(context).primaryColor,
                 foregroundColor: Colors.white,
              ),
              child: Text(_currentStep < _steps.length - 1 ? 'Suivant' : "S'inscrire"), // Correction de la syntaxe du texte
            ),

             // Bouton Retour à la connexion si sur la première étape
             if (_currentStep == 0) // Correction de la syntaxe if
               TextButton(
                 onPressed: () {
                   context.go('/login');
                 },
                 child: const Text('Retour à la connexion'),
               ),
          ],
        ),
      ),
    );
  }
}
