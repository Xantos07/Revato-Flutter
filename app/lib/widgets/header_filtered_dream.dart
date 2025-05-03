import 'package:app/controller/tag_controller.dart';
import 'package:flutter/material.dart';
import '../models/tag_model.dart' as models;
import '../viewmodels/hearder_filter_view_model.dart';
import '../models/app_colors.dart' as models;

class HeaderFilteredDream extends StatefulWidget {
  const HeaderFilteredDream({Key? key}) : super(key: key);

  @override
  State<HeaderFilteredDream> createState() => _HeaderFilteredDreamState();
}

class _HeaderFilteredDreamState extends State<HeaderFilteredDream> {

  late HeaderFilterViewModel headerFilterViewModel;
  late List<models.TagModel> allTags;

  void initState(){
    super.initState();
    headerFilterViewModel = HeaderFilterViewModel();
    _loadTags();
    allTags = [];

  }

  void _loadTags() async {
    try {
      allTags = await headerFilterViewModel.fetchTags();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement tags initiaux : $e')),
      );
    }

    print('📦 Catégories récupérées : ${allTags.map((t) => t.name).toSet()}');
  }
  void _openTagSelector() async {

    String selectedCategory = 'beforeEvent';
    TextEditingController searchController = TextEditingController();

    final categories = {
      'beforeEvent': 'Événement',
      'beforeFeeling': 'Ressenti veille',
      'dreamFeeling': 'Ressenti rêve',
    };

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // 🔁 Recalcul ici à chaque rebuild
            final tagsByCategory = {
              for (var key in categories.keys)
                key: allTags.where((t) => t.category == key).toList()
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
                    onChanged: (value) {
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: categories.entries.map((entry) {
                      final isSelected = selectedCategory == entry.key;
                      return ChoiceChip(
                        label: Text(entry.value),
                        selected: isSelected,
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                        onSelected: (_) {
                          setModalState(() {
                            selectedCategory = entry.key;
                            // 💬 Impression des tags associés à cette catégorie
                            final newVisibleTags = allTags
                                .where((t) => t.category == selectedCategory)
                                .map((t) => t.name)
                                .toList();

                            print('🔍 Tags pour $selectedCategory : $newVisibleTags');
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: ListView(
                      children: visibleTags.map((tag) {
                        final isSelected = headerFilterViewModel.selectedTags.contains(tag.name);
                        return ListTile(
                          title: Text(
                            tag.name,
                            style: TextStyle(color: models.getColorForCategory(tag.category)),
                          ),
                          trailing: isSelected ? const Icon(Icons.check, color: Colors.deepPurple) : null,
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                headerFilterViewModel.removeTag(tag.name);
                              } else {
                                headerFilterViewModel.addTag(tag.name);
                              }
                            });
                            setState(() {}); // pour l'extérieur
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
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        headerFilterViewModel.toggleFilterMode();
                      });
                    },
                    child: Text(headerFilterViewModel.filterMode),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: headerFilterViewModel.selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          headerFilterViewModel.updateDate(picked);
                        });
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(color: Colors.deepPurple),
                    ),
                    child: Text(
                      headerFilterViewModel.selectedDate == null
                          ? 'Choisir une date'
                          : "${headerFilterViewModel.selectedDate!.day.toString().padLeft(2, '0')}/"
                          "${headerFilterViewModel.selectedDate!.month.toString().padLeft(2, '0')}/"
                          "${headerFilterViewModel.selectedDate!.year}",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.deepPurple,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _openTagSelector,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: headerFilterViewModel.selectedTags.map((tagName) {
                final tag = allTags.firstWhere(
                      (t) => t.name == tagName,
                  orElse: () => models.TagModel(name: tagName, category: 'default'),
                );
                final color = models.getColorForCategory(tag.category);
                return Chip(
                  label: Text(tag.name),
                  backgroundColor: color,
                  labelStyle: const TextStyle(color: Colors.white),
                  deleteIconColor: Colors.white,
                  onDeleted: () {
                    setState(() {
                      headerFilterViewModel.removeTag(tag.name);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


}