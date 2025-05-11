import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

enum CustomPassStrength implements PasswordStrengthItem {
  weak,
  medium,
  strong,
  secure;

  @override
  Color get statusColor {
    switch (this) {
      case CustomPassStrength.weak:
        return Colors.red;
      case CustomPassStrength.medium:
        return Colors.orange;
      case CustomPassStrength.strong:
        return Colors.green;
      case CustomPassStrength.secure:
        return Color(0xFFEAAE53);
    }
  }

  @override
  double get widthPerc {
    switch (this) {
      case CustomPassStrength.weak:
        return 0.2;
      case CustomPassStrength.medium:
        return 0.5;
      case CustomPassStrength.strong:
        return 0.75;
      case CustomPassStrength.secure:
        return 1.0;
    }
  }

  @override
  Widget? get statusWidget {
    switch (this) {
      case CustomPassStrength.weak:
        return const Text('Faible');
      case CustomPassStrength.medium:
        return const Text('Moyen');
      case CustomPassStrength.strong:
        return const Text('Fort');
      case CustomPassStrength.secure:
        return Row(
          children: [
            const Text('Sécurisé'),
            Icon(Icons.check_circle, color: statusColor),
          ],
        );
    }
  }

  static CustomPassStrength? calculate({required String text}) {
    if (text.isEmpty) return null;
    if (text.length < 7) return CustomPassStrength.weak;

    int score = 0;
    if (text.contains(RegExp(r'[a-z]'))) score++;
    if (text.contains(RegExp(r'[A-Z]'))) score++;
    if (text.contains(RegExp(r'[0-9]'))) score++;
    if (text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) score++;

    if (score >= 4 && text.length >= 15) {
      return CustomPassStrength.secure;
    } else if (score >= 3) {
      return CustomPassStrength.strong;
    } else if (score >= 2) {
      return CustomPassStrength.medium;
    } else {
      return CustomPassStrength.weak;
    }
  }

  /// Instructions for the password strength.
  static String get instructions {
    return 'Enter a password that contains:\n\n'
        '• At least $kDefaultStrengthLength characters\n'
        '• At least 2 lowercase letter\n'
        '• At least 2 uppercase letter\n'
        '• At least 2 digit\n'
        '• At least 2 special character';
  }
}
