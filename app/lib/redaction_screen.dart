import 'package:app/models/dream.dart';
import 'package:flutter/material.dart';
import '../widgets/header_dream.dart';
import '../widgets/step_page.dart';
import 'dream_form_data.dart';
import '../controller/dream_controller.dart';

class RedactionScreen extends StatefulWidget {
  const RedactionScreen({super.key});

  @override
  State<RedactionScreen> createState() => _RedactionScreenState();
}

class _RedactionScreenState extends State<RedactionScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final int totalPages = 8;

  final DreamFormData formData = DreamFormData(
    title: '',
    actors: [],
    locations: [],
    content: '',
    feeling: '',
    tagsBeforeEvent: [],
    tagsBeforeFeeling: [],
    tagsDreamFeeling: [],
  );

  void _nextPage() async {
    print("📝 Données actuelles : ${formData.toJson()}");

    if (_pageIndex < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final dream = formData.toDream();
      final success = await DreamController().createDream(dream);


      if (success) {
        debugPrint("✅ Rêve envoyé !");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rêve envoyé avec succès !")),
          );
        }
      } else {
        debugPrint("❌ Échec de l'envoi.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erreur lors de l'envoi.")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderDream(currentPage: _pageIndex, totalPages: totalPages),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              children: [
                StepPage(title: "Titre du rêve", hint: "Ex : Le château volant",onChanged: (value) => formData.title = value),
                 StepPage(title: "Acteurs", isList: true, hint: "Acteur",   onListChanged: (value) => formData.actors = value),
                 StepPage(title: "Lieux", isList: true, hint: "Lieux", onListChanged: (value) => formData.locations = value),
                 StepPage(title: "Notation du rêve", hint: "Ex : Tout commença lorsque je me retrouve dans ma maison à côté de mon chien..." , isLongText: true, onChanged: (value) => formData.content = value),
                 StepPage(title: "Notation du ressenti du rêve", hint: "Ex : Le rêve commença très bien mais j'ai vite eu peur" , isLongText: true,onChanged: (value) => formData.feeling = value),
                 StepPage(title: "Tag événementiel de la veille", isList: true, hint: "Tag événementiel de la veille",onListChanged: (value) => formData.tagsBeforeEvent = value),
                 StepPage(title: "Tag ressenti la veille", isList: true, hint: "Tag ressenti la veille",onListChanged: (value) => formData.tagsBeforeFeeling = value),
                 StepPage(title: "Tag ressenti dans le rêve", isList: true, hint: "Tag ressenti dans le rêve",onListChanged: (value) => formData.tagsDreamFeeling = value),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ElevatedButton.icon(
                  onPressed: _nextPage,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    _pageIndex == totalPages - 1 ? "Terminer" : "Suivant",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}