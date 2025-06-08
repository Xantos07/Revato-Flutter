import 'package:flutter/material.dart';
import '../../models/tag_model.dart';
import '../../viewmodels/hearder_filter_view_model.dart';
import '../../models/app_colors.dart' as models;

class TagSelector extends StatefulWidget {
  final List<TagModel> allTags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsUpdated;

  const TagSelector({
    Key? key,
    required this.allTags,
    required this.selectedTags,
    required this.onTagsUpdated,
  }) : super(key: key);

  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late HeaderFilterViewModel headerFilterViewModel;
  String selectedCategory = 'beforeEvent';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    headerFilterViewModel = HeaderFilterViewModel();
    headerFilterViewModel.selectedTags = List.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    final categories = {
      'beforeEvent': 'Événement veille',
      'beforeFeeling': 'Ressenti veille',
      'dreamFeeling': 'Ressenti rêve',
    };

    final tagsByCategory = {
      for (var key in categories.keys)
        key: widget.allTags.where((t) => t.category == key).toList(),
    };
    final visibleTags = tagsByCategory[selectedCategory]!;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Ajouter un tag"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher un tag...',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                categories.entries.map((entry) {
                  final isSelected = selectedCategory == entry.key;
                  return ChoiceChip(
                    label: SizedBox(
                      width: 120,
                      child: Center(child: Text(entry.value)),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected:
                        (_) => setState(() {
                          selectedCategory = entry.key;
                        }),
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView(
              children:
                  visibleTags.map((tag) {
                    final isSelected = headerFilterViewModel.selectedTags
                        .contains(tag.name);
                    return ListTile(
                      title: Text(
                        tag.name,
                        style: TextStyle(
                          color: models.getColorForCategory(tag.category),
                        ),
                      ),
                      trailing:
                          isSelected
                              ? const Icon(
                                Icons.check,
                                color: Colors.deepPurple,
                              )
                              : null,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            headerFilterViewModel.removeTag(tag.name);
                          } else {
                            headerFilterViewModel.addTag(tag.name);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Fermer'),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onTagsUpdated(headerFilterViewModel.selectedTags);
          },
        ),
      ],
    );
  }
}
