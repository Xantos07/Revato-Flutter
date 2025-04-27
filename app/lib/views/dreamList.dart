import 'package:flutter/material.dart';
import '../models/dream.dart';
import '../../controller/dream_controller.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key? key}) : super(key: key);

  @override
  State<DreamList> createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  late Future<List<Dream>> futureTasks;
  final DreamController dreamController = DreamController();

  @override
  void initState() {
    super.initState();
    futureTasks = dreamController.getDreams();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Dream>>(
      future: futureTasks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun rêve trouvé.'));
        } else {
          final dreams = snapshot.data!;
          return ListView.builder(
            itemCount: dreams.length,
            itemBuilder: (context, index) {
              final dream = dreams[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: ListTile(
                  title: Text(dream.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sentiment : ${dream.feeling}'),
                      if (dream.actors.isNotEmpty)
                        Text('Acteurs : ${dream.actors.join(", ")}'),
                      if (dream.locations.isNotEmpty)
                        Text('Lieux : ${dream.locations.join(", ")}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        }
      },
    );
  }

}
