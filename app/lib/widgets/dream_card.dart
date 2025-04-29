import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../models/app_colors.dart'; // si tu utilises des couleurs custom

class DreamCard extends StatelessWidget {
  final Dream dream;
  const DreamCard({required this.dream, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              dream.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                ...dream.tagsBeforeEvent.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.previousEvent,
                  labelStyle: TextStyle(color: Colors.white),
                )),
                ...dream.tagsBeforeFeeling.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.previousFeeling,
                  labelStyle: TextStyle(color: Colors.white),
                )),
                ...dream.tagsDreamFeeling.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: AppColors.dreamFeeling,
                  labelStyle: TextStyle(color: Colors.white),
                )),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              dream.content.length > 20
                  ? '${dream.content.substring(0, 40)}...'
                  : dream.content,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),

          ],
        ),
      ),
    );
  }
}
