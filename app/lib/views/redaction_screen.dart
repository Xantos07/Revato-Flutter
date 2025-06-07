import 'package:flutter/material.dart';
import '../../widgets/page_header.dart';
import '../../widgets/step_page.dart';
import '../../viewmodels/redaction_viewmodel.dart';
import '../models/app_colors.dart';
import '../models/dream.dart';
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

      if (success) {
        setState(() {
          viewModel.formData.reset();
          _pageIndex = 0;
          _pageController.jumpToPage(0);
        });
      }
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
    const bottomPadding = 10.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            PageHeader(title: "Rédiger votre rêve ✨", currentPage: _pageIndex, totalPages: totalPages,),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _pageIndex = idx),
                children: [
                  StepPage(
                    title: "Titre du rêve",
                    isList: false,
                    hint: "Ex : Le château volant",
                    initialValue: viewModel.formData.title,
                    onChanged: (v) => viewModel.formData.title = v,
                  ),
                  StepPage(
                    title: "Acteurs",
                    isList: true,
                    hint: "Acteur",
                    initialList: viewModel.formData.actors,
                    onListChanged: (v) => viewModel.formData.actors = v,
                  ),
                  StepPage(
                    title: "Lieux",
                    isList: true,
                    hint: "Lieux",
                    initialList: viewModel.formData.locations,
                    onListChanged: (v) => viewModel.formData.locations = v,
                  ),
                  StepPage(
                    title: "Notation du rêve",
                    isLongText: true,
                    hint: "Ex : Tout commença lorsque je me retrouve dans ma maison à côté de mon chien...",
                    initialValue: viewModel.formData.content,
                    onChanged: (v) => viewModel.formData.content = v,
                  ),
                  StepPage(
                    title: "Ressenti du rêve",
                    isLongText: true,
                    hint: "Ex : Le rêve commença très bien mais j'ai vite eu peur",
                    initialValue: viewModel.formData.feeling,
                    onChanged: (v) => viewModel.formData.feeling = v,
                  ),
                  StepPage(
                    title: "Tag événementiel de la veille",
                    isList: true,
                    hint: "Tag événementiel de la veille",
                    initialList: viewModel.formData.tagsBeforeEvent,
                    onListChanged: (v) => viewModel.formData.tagsBeforeEvent = v,
                    chipColor: AppColors.previousEvent,
                  ),
                  StepPage(
                    title: "Tag ressenti la veille",
                    isList: true,
                    hint: "Tag ressenti la veille",
                    initialList: viewModel.formData.tagsBeforeFeeling,
                    onListChanged: (v) => viewModel.formData.tagsBeforeFeeling = v,
                    chipColor: AppColors.previousFeeling,
                  ),
                  StepPage(
                    title: "Tag ressenti dans le rêve",
                    isList: true,
                    hint: "Tag ressenti dans le rêve",
                    initialList: viewModel.formData.tagsDreamFeeling,
                    onListChanged: (v) => viewModel.formData.tagsDreamFeeling = v,
                    chipColor: AppColors.dreamFeeling,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_pageIndex > 0)
                      ElevatedButton.icon(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Retour"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(130, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 130),

                    ElevatedButton.icon(
                      onPressed: _nextPage,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        _pageIndex == totalPages - 1 ? "Terminer" : "Suivant",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.baseColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(130, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
