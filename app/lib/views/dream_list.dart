// lib/views/dream_list.dart

import 'package:flutter/material.dart';
import '../../models/dream.dart';
import '../../viewmodels/dream_list_viewmodel.dart';
import '../widgets/dream_card.dart';
import '../widgets/dream_section.dart';
import '../widgets/header_filtered_dream.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  final DreamListViewModel _viewModel = DreamListViewModel();
  late Future<Map<DateTime, List<Dream>>> _groupedDreams;

  @override
  void initState() {
    super.initState();
    _groupedDreams = _viewModel.getGroupedDreams();
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
        if (grouped.isEmpty) {
          return const Center(child: Text('Aucun rêve trouvé.'));
        }

        return ListView(
          children: [
            const HeaderFilteredDream(),
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
