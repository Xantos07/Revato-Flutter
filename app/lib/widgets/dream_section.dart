import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class DreamSection extends StatelessWidget {
  final DateTime date;

  const DreamSection({
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final dateFormatted = "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text(
              dateFormatted,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
