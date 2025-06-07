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

  // On déclare un Future pour charger les tags (une seule fois)
  late final Future<List<TagModel>> _allTagsFuture;

  // Gestion des rêves filtrés
  late Future<Map<DateTime, List<Dream>>> _groupedDreams;
  List<String> _activeTags = [];
  DateTimeRange? _activeDateRange;

  @override
  void initState() {
    super.initState();

    // Instancie le ViewModel pour les filtres
    _headerFilterViewModel = HeaderFilterViewModel();

    // Lance l’appel asynchrone pour charger tous les tags
    _allTagsFuture = _headerFilterViewModel.fetchTags();

    // Précharge les rêves (au moins une première fois) sans filtres
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
      builder: (ctxDreams, snapshotDreams) {
        if (snapshotDreams.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshotDreams.hasError) {
          return Center(child: Text('Erreur: ${snapshotDreams.error}'));
        }

        final grouped = snapshotDreams.data ?? {};

        return ListView(
          children: [
            const PageHeader(title: 'Liste des rêves'),

            // ─────────────────────────────────────────────────────────────
            // À présent, on attend aussi le chargement des TAGS
            // ─────────────────────────────────────────────────────────────
            FutureBuilder<List<TagModel>>(
              future: _allTagsFuture,
              builder: (ctxTags, snapshotTags) {
                if (snapshotTags.connectionState == ConnectionState.waiting) {
                  // Si on veut, on peut mettre un placeholder minuscule :
//                  return const SizedBox(
//                    height: 60,
//                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                  );
                  // Mais on peut aussi attendre avant d’afficher HeaderFilteredDream.
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshotTags.hasError) {
                  return Center(child: Text('Impossible de charger les tags : ${snapshotTags.error}'));
                }

                final allTags = snapshotTags.data!;

                // ───────────────────────────────────────────────────────
                // Quand les tags sont là, on affiche le header de filtres
                // ───────────────────────────────────────────────────────
                return HeaderFilteredDream(
                  // On passe la liste de tags chargée (une seule fois)
                  allTags: allTags,
                  selectedTags: _activeTags,
                  selectedDateRange: _activeDateRange,
                  onFilterChanged: (tags, range) {
                    setState(() {
                      _activeTags = tags;
                      _activeDateRange = range;
                      _groupedDreams = _loadFilteredDreams();
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Affichage des rêves groupés
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
