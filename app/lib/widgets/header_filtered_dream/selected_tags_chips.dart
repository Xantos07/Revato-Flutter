import 'package:flutter/material.dart';
import '../../models/tag_model.dart';
import '../../models/app_colors.dart';

class SelectedTagsChips extends StatelessWidget{
  final List<String> selectedTags;
  final List<TagModel> allTags;
  final Function(String) onTagRemoved;

  const SelectedTagsChips({
    Key? key,
    required this.selectedTags,
    required this.allTags,
    required this.onTagRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: selectedTags.map((tagName) {
        // On récupère l’objet TagModel pour la couleur
        final tag = allTags.firstWhere(
              (t) => t.name == tagName,
          orElse: () => TagModel(name: tagName, category: 'default'),
        );
        final color = getColorForCategory(tag.category);

        return Chip(
          label: Text(tag.name),
          backgroundColor: color,
          labelStyle: const TextStyle(color: Colors.white),
          deleteIconColor: Colors.white,
          onDeleted: () => onTagRemoved(tag.name),
        );
      }).toList(),
    );
  }
}
