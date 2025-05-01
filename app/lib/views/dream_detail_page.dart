import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../models/app_colors.dart';
import '../widgets/highlight_tags_in_content.dart';
import '../widgets/page_header.dart';

class DreamDetailPage extends StatelessWidget {
  final Dream dream;
  const DreamDetailPage({Key? key, required this.dream}) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  List<Widget> _buildColoredChips(List<String> tags, Color color) {
    return tags.map((tag) => Chip(
      label: Text(tag),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            PageHeader(title: dream.title),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...dream.actors.map((a) => Chip(label: Text("👤 $a"))),
                  ...dream.locations.map((l) => Chip(label: Text("📍 $l"))),
                ],
              ),
            ),


            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tags associés :", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...dream.tagsBeforeEvent.map((t) => Chip(
                        label: Text(t),
                        backgroundColor: AppColors.previousEvent.withOpacity(0.2),
                        labelStyle: TextStyle(color: AppColors.previousEvent),
                      )),
                      ...dream.tagsBeforeFeeling.map((t) => Chip(
                        label: Text(t),
                        backgroundColor: AppColors.previousFeeling.withOpacity(0.2),
                        labelStyle: TextStyle(color: AppColors.previousFeeling),
                      )),
                      ...dream.tagsDreamFeeling.map((t) => Chip(
                        label: Text(t),
                        backgroundColor: AppColors.dreamFeeling.withOpacity(0.2),
                        labelStyle: TextStyle(color: AppColors.dreamFeeling),
                      )),
                    ],
                  ),
                ],
              ),
            ),


            // Bloc contenu + tags
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
                  children: highlightTagsInContent(dream.content, dream),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                      child:
                      Text(dream.feeling, style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
