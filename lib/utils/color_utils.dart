import 'package:flutter/material.dart';

Color getAlertColor(double temperature) {
  if (temperature > 10) return const Color(0xFF567F44);
  if (temperature > 8) return const Color(0xFF7BB31A);
  if (temperature > 6) return const Color(0xFFEEDB00);
  if (temperature > 4) return const Color(0xFFFFA500);
  return const Color(0xFFB22222);
}
