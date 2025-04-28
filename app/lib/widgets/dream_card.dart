import 'package:flutter/material.dart';
import '../models/dream.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;
  const DreamCard({ required this.dream, Key? key }) : super(key: key);

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
            Text(
              dream.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              dream.content,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),

            //  ici un Wrap de chips pour acteurs / lieux, etc.
          ],
        ),
      ),
    );
  }
}
