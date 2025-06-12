import 'package:flutter/material.dart';
import '../../viewmodels/hearder_filter_view_model.dart';
import 'filter_container.dart';
import 'selected_tags_chips.dart';
import '../../models/tag_model.dart';
import 'tag_selector.dart';

// Wrapper
class HeaderFilteredDream extends StatefulWidget {
  final List<TagModel> allTags;
  final List<String> selectedTags;
  final DateTimeRange? selectedDateRange;
  final Function(List<String>, DateTimeRange?) onFilterChanged;

  const HeaderFilteredDream({
    Key? key,
    required this.allTags,
    required this.selectedTags,
    required this.selectedDateRange,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  _HeaderFilteredDreamState createState() => _HeaderFilteredDreamState();
}

class _HeaderFilteredDreamState extends State<HeaderFilteredDream> {
  late HeaderFilterViewModel headerFilterViewModel;
  //late List<TagModel> allTags;

  @override
  void initState() {
    super.initState();

    // instancie le ViewModel
    headerFilterViewModel = HeaderFilterViewModel();

    // injecte les valeurs initiales de tags + date dans le ViewModel
    headerFilterViewModel.selectedTags = List.from(widget.selectedTags);
    if (widget.selectedDateRange != null) {
      headerFilterViewModel.selectedDateRange = widget.selectedDateRange;
    }

    //  On charge la liste complète des tags (async)
    //allTags = []; // Valeur par défaut (vide) le temps du chargement
    //_loadTags();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: FilterContainer(
              viewModel: headerFilterViewModel,
              selectedTags: headerFilterViewModel.selectedTags,
              allTags: widget.allTags,
              onToggleFilterMode: () {
                setState(() {
                  headerFilterViewModel.toggleFilterMode();
                });
              },
              onDateRangePicked: (pickedRange) {
                print('📅 Date sélectionnée dans FilterContainer: $pickedRange');
                if (pickedRange != null) {
                  setState(() {
                    headerFilterViewModel.updateDateRange(pickedRange);
                  });
                  widget.onFilterChanged(
                    headerFilterViewModel.selectedTags,
                    pickedRange,
                  );
                }
              },
              onClearDate: () {
                setState(() {
                  headerFilterViewModel.clearDate();
                  widget.onFilterChanged(
                    headerFilterViewModel.selectedTags,
                    null,
                  );
                });
              },
              onOpenTagSelector: _openTagSelector,
              onTagRemoved: (tagName) {
                setState(() {
                  headerFilterViewModel.removeTag(tagName);
                  widget.onFilterChanged(
                    headerFilterViewModel.selectedTags,
                    headerFilterViewModel.selectedDateRange,
                  );
                });
              },
              onFilterChanged: widget.onFilterChanged,
            ),
          ),

          const SizedBox(height: 12),

          // Affichage des chips sous forme de tags
          Center(
            child: SelectedTagsChips(
              selectedTags: headerFilterViewModel.selectedTags,
              allTags: widget.allTags,
              onTagRemoved: (tagName) {
                setState(() {
                  headerFilterViewModel.removeTag(tagName);
                  widget.onFilterChanged(
                    headerFilterViewModel.selectedTags,
                    headerFilterViewModel.selectedDateRange,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Charge en asynchrone la liste complète des tags depuis le ViewModel
  /*void _loadTags() async {
    try {
      final tags = await headerFilterViewModel.fetchTags();
      setState(() {
        allTags = tags;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement tags initiaux : $e')),
      );
    }
  }*/

  /// Ouvre la boîte de dialogue pour sélectionner des tags
  void _openTagSelector() async {
    await showDialog(
      context: context,
      builder: (_) => TagSelector(
        allTags: widget.allTags,
        selectedTags: headerFilterViewModel.selectedTags,
        onTagsUpdated: (newTags) {
          setState(() {
            headerFilterViewModel.selectedTags = newTags;
            widget.onFilterChanged(
              newTags,
              headerFilterViewModel.selectedDateRange,
            );
          });
        },
      ),
    );
  }
}
