import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../models/app_colors.dart';
import '../views/dream_detail_page.dart';

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

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => DreamDetailPage(dream: dream)),
      ),

      // ← Ici child: pour englober ton Container
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3.0,
              spreadRadius: 1.0,
              offset: Offset.zero,
            ),
          ],
        ),
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
              dream.content.length > 40
                  ? '${dream.content.substring(0, 40)}…'
                  : dream.content,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );

  }
}
