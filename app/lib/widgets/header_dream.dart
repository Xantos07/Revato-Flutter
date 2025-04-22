import 'package:flutter/material.dart';

class HeaderDream extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const HeaderDream({super.key, required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const Text(
            "Rédiger votre Rêve ✨",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              bool isDone = index < currentPage;
              bool isCurrent = index == currentPage;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isCurrent ? 16 : 12,
                height: isCurrent ? 16 : 12,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Colors.yellow
                      : isDone
                      ? Colors.greenAccent
                      : Colors.white54,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}