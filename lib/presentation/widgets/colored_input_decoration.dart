import 'package:flutter/material.dart';
import '../../domain/models/app_theme_settings.dart';

/// Crée un InputDecoration avec des bordures colorées dynamiques
InputDecoration createColoredInputDecoration({
  required String labelText,
  String? hintText,
  required Widget prefixIcon,
  required Color primaryColor,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
  );
}
