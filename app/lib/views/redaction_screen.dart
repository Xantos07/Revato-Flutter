import 'package:flutter/material.dart';
import '../../widgets/header_dream.dart';
import '../../widgets/step_page.dart';
import '../../viewmodels/redaction_viewmodel.dart';

class RedactionScreen extends StatefulWidget {
  const RedactionScreen({super.key});

  @override
  State<RedactionScreen> createState() => _RedactionScreenState();
}

class _RedactionScreenState extends State<RedactionScreen> {
  final PageController _pageController = PageController();
  final RedactionViewModel viewModel = RedactionViewModel();

  int _pageIndex = 0;
  final int totalPages = 8;

  void _nextPage() async {
    print("📝 Données actuelles : ${viewModel.formData.toJson()}");

    if (_pageIndex < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final success = await viewModel.submitDream();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "✅ Rêve envoyé avec succès !"
                : "❌ Erreur lors de l'envoi.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onChanged: (v) => viewModel.formData.title = v,
                  ),
                  StepPage(
                    title: "Acteurs",
                    isList: true,
                    hint: "Acteur",
                    onListChanged: (v) => viewModel.formData.actors = v,
                  ),
                  StepPage(
                    title: "Lieux",
                    isList: true,
                    hint: "Lieux",
                    onListChanged: (v) => viewModel.formData.locations = v,
                  ),
                  StepPage(
                    title: "Notation du rêve",
                    isLongText: true,
                    hint: "Ex : Tout commença lorsque je me retrouve dans ma maison à côté de mon chien...",
                    onChanged: (v) => viewModel.formData.content = v,
                  ),
                  StepPage(
                    title: "Ressenti du rêve",
                    isLongText: true,
                    hint: "Ex : Le rêve commença très bien mais j'ai vite eu peur",
                    onChanged: (v) => viewModel.formData.feeling = v,
                  ),
                  StepPage(
                    title: "Tag événementiel de la veille",
                    isList: true,
                    hint: "Tag événementiel de la veille",
                    onListChanged: (v) => viewModel.formData.tagsBeforeEvent = v,
                  ),
                  StepPage(
                    title: "Tag ressenti la veille",
                    isList: true,
                    hint: "Tag ressenti la veille",
                    onListChanged: (v) => viewModel.formData.tagsBeforeFeeling = v,
                  ),
                  StepPage(
                    title: "Tag ressenti dans le rêve",
                    isList: true,
                    hint: "Tag ressenti dans le rêve",
                    onListChanged: (v) => viewModel.formData.tagsDreamFeeling = v,
                  ),
                ],
              ),
            ),
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
