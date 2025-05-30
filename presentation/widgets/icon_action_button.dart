// lib/presentation/widgets/icon_action_button.dart
import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const IconActionButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 60.0, // Taille par défaut du bouton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.6, // Taille de l'icône par rapport au bouton
        ),
      ),
    );
  }
}
