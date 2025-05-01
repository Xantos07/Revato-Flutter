import 'package:flutter/material.dart';

class AppColors {
  static const Color previousFeeling   = Color(0xFF6B5BE7); // violet
  static const Color dreamFeeling      = Color(0xFFEAAE53); // jaune
  static const Color previousEvent     = Color(0xFF70C166); // vert
}

Color getColorForCategory(String category) {
  switch (category) {
    case 'beforeEvent':
      return Color(0xFF70C166);
    case 'beforeFeeling':
      return Color(0xFF6B5BE7);
    case 'dreamFeeling':
      return Color(0xFFEAAE53);
    default:
      return Colors.grey;
  }
}