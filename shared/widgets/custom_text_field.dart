// TODO Implement this library.
// lib/shared/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final bool enabled; // Pour gérer l'état activé/désactivé
  final int? maxLength; // Ajout du maxLength

  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1, // Par défaut, une seule ligne
    this.minLines,
    this.enabled = true, // Par défaut, activé
    this.maxLength, // Initialisation du maxLength
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      maxLength: maxLength, // Ajout du maxLength au TextFormField
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Appliquer le radius spécifié
          borderSide: BorderSide.none, // Enlever la bordure par défaut si vous utilisez fillColor
        ),
        filled: true, // Remplir le fond
        fillColor: Colors.grey[200], // Couleur de fond basique (peut être ajustée via thème)
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Espacement intérieur
      ),
    );
  }
}
