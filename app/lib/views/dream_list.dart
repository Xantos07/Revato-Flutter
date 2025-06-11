import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../models/tag_model.dart';
import '../viewmodels/dream_list_viewmodel.dart';
import '../viewmodels/hearder_filter_view_model.dart';
import '../widgets/dream_card.dart';
import '../widgets/dream_section.dart';
import '../widgets/header_filtered_dream/header_filtered_dream.dart';
import '../widgets/page_header.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  final DreamListViewModel _viewModel = DreamListViewModel();
  late final HeaderFilterViewModel _headerFilterViewModel;
  final List<dynamic> _groupedDreamsList = [];

  // Pagination
  int _currentPage = 1;
  final int _pageSize = 3;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // Données
  List<Dream> _allDreams = [];

  // Filtres
  List<String> _activeTags = [];
  DateTimeRange? _activeDateRange;

  // Tags
  late final Future<List<TagModel>> _allTagsFuture;

  @override
  void initState() {
    super.initState();
    _headerFilterViewModel = HeaderFilterViewModel();
    _allTagsFuture = _headerFilterViewModel.fetchTags();
    _loadMoreDreams(); // Charge la première page
  }

  Future<void> _loadMoreDreams() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newDreams = await _viewModel.getDreamsByPage(
        _currentPage,
        _pageSize,
        _activeTags,
      );


      if (!mounted) return;

      setState(() {
        _allDreams.addAll(newDreams);
        _currentPage++;
        _hasMore = newDreams.length == _pageSize;
        _rebuildGroupedList();
      });
    } catch (e) {
      if (!mounted) return;
      print('❌ Erreur lors du chargement : $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _rebuildGroupedList() {
    _groupedDreamsList.clear();
    _allDreams.sort((a, b) => b.date.compareTo(a.date));
    DateTime? lastDate;
    for (final dream in _allDreams) {
      final dateKey = DateTime(dream.date.year, dream.date.month, dream.date.day);
      if (lastDate == null || lastDate != dateKey) {
        _groupedDreamsList.add(dateKey);
        lastDate = dateKey;
      }
      _groupedDreamsList.add(dream);
    }
  }


  void _onFilterChanged(List<String> tags, DateTimeRange? range) {
    setState(() {
      _activeTags = tags;
      _activeDateRange = range;
      _currentPage = 1;
      _hasMore = true;
      _allDreams.clear();
    });
    _loadMoreDreams();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Liste des rêves'),

        FutureBuilder<List<TagModel>>(
          future: _allTagsFuture,
          builder: (ctxTags, snapshotTags) {
            if (snapshotTags.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshotTags.hasError) {
              return Center(
                  child:
                  Text('Impossible de charger les tags : ${snapshotTags.error}'));
            }

            final allTags = snapshotTags.data!;

            return HeaderFilteredDream(
              allTags: allTags,
              selectedTags: _activeTags,
              selectedDateRange: _activeDateRange,
              onFilterChanged: _onFilterChanged,
            );
          },
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: _groupedDreamsList.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _groupedDreamsList.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _loadMoreDreams();
                });
                return const Center(child: CircularProgressIndicator());
              }

              final item = _groupedDreamsList[index];

              if (item is DateTime) {
                return DreamSection(date: item);
              } else if (item is Dream) {
                return DreamCard(dream: item);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        )
      ],
    );
  }
}
