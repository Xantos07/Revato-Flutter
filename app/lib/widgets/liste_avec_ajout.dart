import 'package:flutter/material.dart';

/// Un widget de saisie avec bouton + et affichage des éléments sous forme de bulles (chips).
class ListeAvecAjout extends StatefulWidget {
  final String hint;
  const ListeAvecAjout({Key? key, required this.hint}) : super(key: key);

  @override
  State<ListeAvecAjout> createState() => _ListeAvecAjoutState();
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
        // Zone de saisie avec bouton +
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
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
              // Bouton rond violet +
              Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  iconSize: 32,
                  splashRadius: 24,
                  onPressed: _ajouterItem,
                ),
              ),
            ],
          ),
        ),

 
        if (_items.isNotEmpty) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _items.map((item) {
                  return InputChip(
                    label: Text(item),
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _items.remove(item);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
