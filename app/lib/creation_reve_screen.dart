import 'package:flutter/material.dart';
import '../widgets/reve_header.dart';
import '../widgets/step_page.dart';

class CreationReveScreen extends StatefulWidget {
  const CreationReveScreen({super.key});

  @override
  State<CreationReveScreen> createState() => _CreationReveScreenState();
}

class _CreationReveScreenState extends State<CreationReveScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  final int totalPages = 8;

  void _nextPage() {
    if (_pageIndex < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("\u{1F680} Fini !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReveHeader(currentPage: _pageIndex, totalPages: totalPages),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              children: const [
                StepPage(title: "Titre du rêve", hint: "Ex : Le château volant"),
                StepPage(title: "Acteurs", isList: true, hint: "Acteur"),
                StepPage(title: "Lieux", isList: true, hint: "Lieux"),
                StepPage(title: "Notation du rêve", hint: "Ex : Tout commença lorsque je me retrouve dans ma maison à côté de mon chien..." , isLongText: true),
                StepPage(title: "Notation du ressenti du rêve", hint: "Ex : Le rêve commença très bien mais j'ai vite eu peur" , isLongText: true),
                StepPage(title: "Tag événementiel de la veille", isList: true, hint: "Tag événementiel de la veille"),
                StepPage(title: "Tag ressenti la veille", isList: true, hint: "Tag ressenti la veille"),
                StepPage(title: "Tag ressenti dans le rêve", isList: true, hint: "Tag ressenti dans le rêve"),
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