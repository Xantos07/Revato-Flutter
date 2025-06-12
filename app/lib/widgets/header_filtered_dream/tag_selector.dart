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

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late HeaderFilterViewModel headerFilterViewModel;
  String selectedCategory = 'beforeEvent';
  TextEditingController searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  List<TagModel> paginatedTags = [];
  int currentPage = 1;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    headerFilterViewModel = HeaderFilterViewModel();
    headerFilterViewModel.selectedTags = List.from(widget.selectedTags);
    _scrollController.addListener(_onScroll);
    loadTags();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        !isLoading &&
        hasMore) {
      loadTags();
    }
  }

  Future<void> loadTags({bool reset = false}) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    if (reset) {
      currentPage = 1;
      paginatedTags.clear();
      hasMore = true;
    }

    final fetched = await headerFilterViewModel.fetchTagsPaginated(
      page: currentPage,
      pageSize: pageSize,
      category: searchController.text.isEmpty ? selectedCategory : null,
      search: searchController.text,
    );


    setState(() {
      currentPage++;
      paginatedTags.addAll(fetched);
      hasMore = fetched.length == pageSize;
      isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    loadTags(reset: true);
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
    });
    loadTags(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final categories = {
      'beforeEvent': 'Événement veille',
      'beforeFeeling': 'Ressenti veille',
      'dreamFeeling': 'Ressenti rêve',
    };

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
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: categories.entries.map((entry) {
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
                onSelected: (_) => _onCategoryChanged(entry.key),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: paginatedTags.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == paginatedTags.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final tag = paginatedTags[index];
                final isSelected =
                headerFilterViewModel.selectedTags.contains(tag.name);

                return ListTile(
                  title: Text(
                    tag.name,
                    style: TextStyle(
                      color: models.getColorForCategory(tag.category),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.deepPurple)
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
              },
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
