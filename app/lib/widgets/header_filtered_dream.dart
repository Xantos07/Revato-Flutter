import 'package:flutter/material.dart';

class HeaderFilteredDream extends StatefulWidget {
  const HeaderFilteredDream({Key? key}) : super(key: key);

  @override
  State<HeaderFilteredDream> createState() => _HeaderFilteredDreamState();
}

class _HeaderFilteredDreamState extends State<HeaderFilteredDream> {
  DateTime? selectedDate;
  String filterMode = 'OU';
  List<String> selectedTags = ['Confiance', 'Joviale'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Le conteneur qui regroupe tout de manière alignée
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // OU / ET toggle
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterMode = filterMode == 'OU' ? 'ET' : 'OU';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.deepPurple.shade50,
                        foregroundColor: Colors.deepPurple,
                        elevation: 0,
                      ),
                      child: Text(filterMode),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Date picker
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: Colors.deepPurple),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? 'Choisir une date'
                          : "${selectedDate!.day.toString().padLeft(2, '0')}/"
                          "${selectedDate!.month.toString().padLeft(2, '0')}/"
                          "${selectedDate!.year}",
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Bouton +
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Material(
                      color: Colors.deepPurple,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          // TODO: sélectionner des tags
                        },
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Affichage des tags sélectionnés
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: selectedTags.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.deepPurple.shade50,
                deleteIconColor: Colors.deepPurple,
                onDeleted: () {
                  setState(() => selectedTags.remove(tag));
                },
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
