import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final int? currentPage; // nullable pour option
  final int? totalPages;

  const PageHeader({
    Key? key,
    required this.title,
    this.currentPage,
    this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
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
          if (currentPage != null && totalPages != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages!, (index) {
                bool isDone = index < currentPage!;
                bool isCurrent = index == currentPage!;
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
          ]
        ],
      ),
    );
  }
}
