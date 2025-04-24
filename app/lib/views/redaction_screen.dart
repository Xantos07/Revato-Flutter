import 'package:flutter/material.dart';
import 'package:app/models/dream.dart';
import '../../widgets/header_dream.dart';
import '../../widgets/step_page.dart';
import '../dream_form_data.dart';
import '../../controller/dream_controller.dart';

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Rêve envoyé avec succès !")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Erreur lors de l'envoi.")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Espace pour ne pas être masqué par la navBar/FAB
    const bottomPadding = 40.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            HeaderDream(currentPage: _pageIndex, totalPages: totalPages),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _pageIndex = idx),
                children: [
                  StepPage(
                    title: "Titre du rêve",
                    hint: "Ex : Le château volant",
                    onChanged: (v) => formData.title = v,
                  ),
                  StepPage(
                    title: "Acteurs",
                    isList: true,
                    hint: "Acteur",
                    onListChanged: (v) => formData.actors = v,
                  ),
                  StepPage(
                    title: "Lieux",
                    isList: true,
                    hint: "Lieux",
                    onListChanged: (v) => formData.locations = v,
                  ),
                  StepPage(
                    title: "Notation du rêve",
                    hint:
                    "Ex : Tout commença lorsque je me retrouve dans ma maison à côté de mon chien...",
                    isLongText: true,
                    onChanged: (v) => formData.content = v,
                  ),
                  StepPage(
                    title: "Ressenti du rêve",
                    hint:
                    "Ex : Le rêve commença très bien mais j'ai vite eu peur",
                    isLongText: true,
                    onChanged: (v) => formData.feeling = v,
                  ),
                  StepPage(
                    title: "Tag événementiel de la veille",
                    isList: true,
                    hint: "Tag événementiel de la veille",
                    onListChanged: (v) => formData.tagsBeforeEvent = v,
                  ),
                  StepPage(
                    title: "Tag ressenti la veille",
                    isList: true,
                    hint: "Tag ressenti la veille",
                    onListChanged: (v) => formData.tagsBeforeFeeling = v,
                  ),
                  StepPage(
                    title: "Tag ressenti dans le rêve",
                    isList: true,
                    hint: "Tag ressenti dans le rêve",
                    onListChanged: (v) => formData.tagsDreamFeeling = v,
                  ),
                ],
              ),
            ),

            // Bouton "Suivant" bien au-dessus du FAB / navBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          ],
        ),
      ),
    );
  }
}
