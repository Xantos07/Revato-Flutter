import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class BottomBackButton extends StatelessWidget {
  final String label;

  final VoidCallback? onPressed;

  const BottomBackButton({
    Key? key,
    this.label = 'Retour',
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.baseColor,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
