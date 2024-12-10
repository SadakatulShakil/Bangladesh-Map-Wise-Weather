import 'package:flutter/material.dart';

class ColorUtils {
  // Threshold colors based on the assignment
  static const Color noAlert = Color(0xFF567F44);
  static const Color mild = Color(0xFF7BB31A);
  static const Color moderate = Color(0xFFEEDB00);
  static const Color severe = Color(0xFFFFA500);
  static const Color extreme = Color(0xFFB22222);

  // Get color based on temperature threshold
  static Color getAlertColor(double temperature) {
    if (temperature <= 4) return extreme;
    if (temperature <= 6) return severe;
    if (temperature <= 8) return moderate;
    if (temperature <= 10) return mild;
    return noAlert;
  }

  // Generate a gradient based on alert level
  static LinearGradient getAlertGradient(double temperature) {
    Color baseColor = getAlertColor(temperature);
    return LinearGradient(
      colors: [
        baseColor.withOpacity(0.7),
        baseColor.withOpacity(0.9),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Generate text color with good contrast
  static Color getContrastTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}