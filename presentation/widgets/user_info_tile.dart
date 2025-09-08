// lib/presentation/widgets/user_info_tile.dart
import 'package:flutter/material.dart';

class UserInfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor; // Optionnel: couleur de l'icône
  final TextStyle? textStyle; // Optionnel: style du texte

  const UserInfoTile({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Petit espacement vertical
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement en haut
        children: [
          Icon(
            icon,
            size: 20, // Taille de l'icône
            color: iconColor ?? Theme.of(context).iconTheme.color, // Utilise la couleur spécifiée ou celle du thème
          ),
          const SizedBox(width: 12), // Espacement entre l'icône et le texte
          Expanded( // Permet au texte de prendre l'espace restant
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium, // Utilise le style spécifié ou celui du thème
              overflow: TextOverflow.ellipsis, // Gère le dépassement de texte
            ),
          ),
        ],
      ),
    );
  }
}
// TODO Implement this library.
