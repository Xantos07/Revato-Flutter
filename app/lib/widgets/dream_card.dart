import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../models/app_colors.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;
  const DreamCard({required this.dream, Key? key}) : super(key: key);

  List<Widget> _buildChips(List<String> tags, Color color) {
    return tags.map((tag) => Chip(
      label: Text(tag),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.white),
    )).toList();
  }

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
                ..._buildChips(dream.tagsBeforeEvent, AppColors.previousEvent),
                ..._buildChips(dream.tagsBeforeFeeling, AppColors.previousFeeling),
                ..._buildChips(dream.tagsDreamFeeling, AppColors.dreamFeeling),
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
