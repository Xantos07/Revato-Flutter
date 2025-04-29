import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../../controller/dream_controller.dart';
import 'dream_section.dart';
import 'dream_card.dart';
import 'header_filtered_dream.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  late Future<List<Dream>> futureDreams;
  final DreamController dreamController = DreamController();

  @override
  void initState() {
    super.initState();
    futureDreams = dreamController.getDreams();
  }

  // Groupe les rêves par date (seulement jour/mois/année)
  Map<DateTime, List<Dream>> _groupByDate(List<Dream> dreams) {
    final map = <DateTime, List<Dream>>{};
    for (var d in dreams) {
      final day = DateTime(d.date.year, d.date.month, d.date.day);
      map.putIfAbsent(day, () => []).add(d);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dream>>(
      future: futureDreams,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Erreur: ${snap.error}'));
        }
        final list = snap.data ?? [];
        if (list.isEmpty) {
          return const Center(child: Text('Aucun rêve trouvé.'));
        }

        final grouped = _groupByDate(list);

        return ListView(
          children: [

          const HeaderFilteredDream(),

            ...grouped.entries.map((entry) {
            final date     = entry.key;
            final dreamsOn = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DreamSection(
                  date: date,
                ),
                ...dreamsOn.map((d) => DreamCard(dream: d)),
              ],
            );
          }).toList(),
        ]);
      },
    );
  }
}
