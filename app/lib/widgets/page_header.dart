import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final int? currentPage; // index de la page courante (0-based)
  final int? totalPages;

  const PageHeader({
    Key? key,
    required this.title,
    this.currentPage,
    this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentPage == null || totalPages == null) {
      return _buildHeaderOnly();
    }

    final steps = <Widget>[];
    for (var i = 0; i < totalPages!; i++) {
      Widget dot;

      if (i < currentPage!) {
        // ✅ étape passée
        dot = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );

      } else if (i == currentPage!) {
        // 🟡 étape courante avec petit cercle intérieur jaune
        dot = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondaryColor, width: 3),
                color: Colors.transparent,
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        );

      } else {
        // ◯ étape à venir avec petit cercle intérieur gris
        dot = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54, width: 3),
                color: Colors.transparent,
              ),
            ),
          ],
        );
      }

      steps.add(dot);

      // Trait de connexion vers la prochaine étape
      if (i < totalPages! - 1) {
        // Choix de la couleur du trait
        Color lineColor;
        if (i < currentPage! - 1) {
          lineColor = Colors.green;
        } else if (i == currentPage! - 1) {
          lineColor = AppColors.secondaryColor;
        } else {
          lineColor = Colors.white54;
        }

        // Parent de 24px de large, avec le trait (16px) centré dedans
        steps.add(
          SizedBox(
            width: 24,
            // ou Container(width: 24) si tu veux des decorations plus tard
            child: Center(
              child: Container(
                width: 16,
                height: 2,
                color: lineColor,
              ),
            ),
          ),
        );
      }

    }

    return Container(
      //color: Colors.deepPurple,
      color: AppColors.baseColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: steps,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderOnly() {
    return Container(
      color: AppColors.baseColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
