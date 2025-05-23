import 'package:flutter/material.dart';
import 'package:app/controller/tag_controller.dart';
import '../models/tag_model.dart' as models;
import '../viewmodels/hearder_filter_view_model.dart';
import '../models/app_colors.dart' as models;
import 'tag_selector.dart';


//Wrapper
class HeaderFilteredDream extends StatefulWidget {
  final List<String> selectedTags;
  final DateTimeRange? selectedDateRange;
  final Function(List<String> tags, DateTimeRange? range) onFilterChanged;

  const HeaderFilteredDream({
    Key? key,
    required this.selectedTags,
    required this.selectedDateRange,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<HeaderFilteredDream> createState() => _HeaderFilteredDreamState();
}

class _HeaderFilteredDreamState extends State<HeaderFilteredDream> {
  late HeaderFilterViewModel headerFilterViewModel;
  late List<models.TagModel> allTags;

  @override
  void initState() {
    super.initState();
    headerFilterViewModel = HeaderFilterViewModel();
    _loadTags();
    allTags = [];

    headerFilterViewModel.selectedTags = List.from(widget.selectedTags);
    headerFilterViewModel.selectedDateRange = widget.selectedDateRange;
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
  }


  String _formatRangeMultiLine(DateTimeRange? range) {
    if (range == null) return 'Choisir\nune plage';
    final start = range.start;
    final end = range.end;
    return "${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}\n"
        "${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}";
  }

  void _openTagSelector() async {
    await showDialog(
      context: context,
      builder: (_) => TagSelector(

        allTags: allTags,
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
                      setState(() => headerFilterViewModel.toggleFilterMode());
                    },
                    child: Text(headerFilterViewModel.filterMode),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          initialDateRange: headerFilterViewModel.selectedDateRange,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialEntryMode: DatePickerEntryMode.input,

                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                child: child!,
                              ),
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            headerFilterViewModel.updateDateRange(picked);
                            widget.onFilterChanged(
                              headerFilterViewModel.selectedTags,
                              headerFilterViewModel.selectedDateRange,
                            );
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                      child: Text(
                        _formatRangeMultiLine(headerFilterViewModel.selectedDateRange),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        headerFilterViewModel.clearDate();
                        widget.onFilterChanged(
                          headerFilterViewModel.selectedTags,
                          null,
                        );
                      });
                    },
                    icon: const Icon(Icons.close),
                    tooltip: "Réinitialiser la date",
                  ),
                  const SizedBox(width: 8),
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
                      widget.onFilterChanged(
                        headerFilterViewModel.selectedTags,
                        headerFilterViewModel.selectedDateRange,
                      );
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
