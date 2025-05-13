// lib/views/dream_list.dart

import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../viewmodels/dream_list_viewmodel.dart';
import '../widgets/dream_card.dart';
import '../widgets/dream_section.dart';
import '../widgets/header_filtered_dream.dart';
import '../widgets/page_header.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  final DreamListViewModel _viewModel = DreamListViewModel();

  late Future<Map<DateTime, List<Dream>>> _groupedDreams;

  List<String> _activeTags = [];
  DateTimeRange? _activeDateRange;

  @override
  void initState() {
    super.initState();
    _groupedDreams = _loadFilteredDreams();
  }

  Future<Map<DateTime, List<Dream>>> _loadFilteredDreams() async {
    final allDreams = await _viewModel.getAllDreams();

    final filtered = allDreams.where((dream) {
      final tagMatch = _activeTags.isEmpty ||
          _activeTags.any((tag) =>
          dream.tagsBeforeEvent.contains(tag) ||
              dream.tagsBeforeFeeling.contains(tag) ||
              dream.tagsDreamFeeling.contains(tag));

      final dateMatch = _activeDateRange == null ||
          (dream.date.isAfter(_activeDateRange!.start.subtract(const Duration(days: 1))) &&
              dream.date.isBefore(_activeDateRange!.end.add(const Duration(days: 1))));


      return tagMatch && dateMatch;
    });

    final Map<DateTime, List<Dream>> grouped = {};
    for (final d in filtered) {
      final dateKey = DateTime(d.date.year, d.date.month, d.date.day);
      grouped.putIfAbsent(dateKey, () => []).add(d);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, List<Dream>>>(
      future: _groupedDreams,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final grouped = snapshot.data ?? {};
        //if (grouped.isEmpty) {return const Center(child: Text('Aucun rêve trouvé.'));}

        return ListView(
          children: [
            PageHeader(title: 'Liste des rêves'),

            HeaderFilteredDream(
              selectedTags: _activeTags,
              selectedDateRange: _activeDateRange,
              onFilterChanged: (tags, range) {
                setState(() {
                  _activeTags = tags;
                  _activeDateRange = range;
                  _groupedDreams = _loadFilteredDreams();
                });
              },
            ),



            ...grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DreamSection(date: entry.key),
                  ...entry.value.map((d) => DreamCard(dream: d)).toList(),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
