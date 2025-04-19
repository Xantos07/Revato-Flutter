import 'package:flutter/material.dart';

void main() {
  runApp(CarrouselReveApp());
}

class CarrouselReveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Création de Rêve',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFF4EDFA),
      ),
      home: CreationReveScreen(),
    );
  }
}

class CreationReveScreen extends StatefulWidget {
  @override
  _CreationReveScreenState createState() => _CreationReveScreenState();
}

class _CreationReveScreenState extends State<CreationReveScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  final int totalPages = 8;

  void _nextPage() {
    if (_pageIndex < totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      print("🚀 Fini !");
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
              onPageChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              children: [
                _StepPage(title: "Titre du rêve", hint: "Ex : Le château volant"),
                _StepPage(title: "Acteurs", customContent: ListeAvecAjout(hint: "Acteur")),
                _StepPage(title: "Lieux", customContent: ListeAvecAjout(hint: "Lieux")),
                _StepPage(title: "Notation du rêve", hint: "Ex : Tout commença lorsque je me retrouve dans ma maison à côté de mon chien..."),
                _StepPage(title: "Notation du ressenti du rêve", hint: "Ex : Le rêve commença très bien mais j'ai vite eu peur"),

                 _StepPage(title: "Tag événementiel de la veille", customContent: ListeAvecAjout(hint: "Tag événementiel de la veille")),
                   _StepPage(title: "Tag ressenti la veille", customContent: ListeAvecAjout(hint: "Tag ressenti la veille")),
                     _StepPage(title: "Tag ressenti dans le rêve", customContent: ListeAvecAjout(hint: "Tag ressenti dans le rêve")),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: ElevatedButton.icon(
                  onPressed: _nextPage,
                  icon: Icon(Icons.arrow_forward),
                  label: Text(_pageIndex == totalPages - 1 ? "Terminer" : "Suivant"),
                  style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Header commun
class ReveHeader extends StatelessWidget {
  final int currentPage;
    final int totalPages;

    const ReveHeader({required this.currentPage, required this.totalPages});

    @override
    Widget build(BuildContext context) {
      return Container(
        color: Colors.deepPurple,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              "Rédiger votre Rêve ✨",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                bool isDone = index < currentPage;
                bool isCurrent = index == currentPage;
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: isCurrent ? 16 : 12,
                  height: isCurrent ? 16 : 12,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.white
                        : isDone
                            ? Colors.greenAccent
                            : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }
  }

// ✅ Chaque page
class _StepPage extends StatelessWidget {
  final String title;
  final String? hint;
  final Widget? customContent;

  const _StepPage({required this.title, this.hint, this.customContent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Le titre centré stylé
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Soit un champ texte simple, soit un widget custom
              if (customContent != null)
                customContent!
              else
                TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    border: OutlineInputBorder(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


  class ListeAvecAjout extends StatefulWidget {
    final String hint;

    const ListeAvecAjout({required this.hint});

    @override
    _ListeAvecAjoutState createState() => _ListeAvecAjoutState();
  }

  class _ListeAvecAjoutState extends State<ListeAvecAjout> {
    final TextEditingController _controller = TextEditingController();
    final List<String> _items = [];

    void _ajouterItem() {
      final texte = _controller.text.trim();
      if (texte.isEmpty) return;

      setState(() {
        _items.add(texte);
        _controller.clear();
      });
    }

    @override
    Widget build(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Champ + bouton +
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.deepPurple),
                  onPressed: _ajouterItem,
                )
              ],
            ),
          ),
          SizedBox(height: 12),
          // Affichage de la liste
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 4),
              child: Text("• $item", style: TextStyle(fontStyle: FontStyle.italic)),
            )).toList(),
          )
        ],
      );
    }
  }



