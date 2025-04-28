import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class DreamSection extends StatelessWidget {
  final DateTime date;
  final List<String> tagsBeforeFeeling;
  final List<String> tagsDreamFeeling;
  final List<String> tagsBeforeEvent;


  const DreamSection({
    required this.date,
    required this.tagsBeforeFeeling,
    required this.tagsDreamFeeling,
    required this.tagsBeforeEvent,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            dateFormatted,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Les 3 chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              // Affiche tous les tagsBeforeFeeling
              ...tagsBeforeFeeling.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: AppColors.previousFeeling.withOpacity(0.2),
                labelStyle: TextStyle(color: AppColors.previousFeeling),
              )),
              // Affiche tous les tagsDreamFeeling
              ...tagsDreamFeeling.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: AppColors.dreamFeeling.withOpacity(0.2),
                labelStyle: TextStyle(color: AppColors.dreamFeeling),
              )),
              // Affiche tous les tagsBeforeEvent
              ...tagsBeforeEvent.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: AppColors.previousEvent.withOpacity(0.2),
                labelStyle: TextStyle(color: AppColors.previousEvent),
              )),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
