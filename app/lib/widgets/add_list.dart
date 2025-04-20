import 'package:flutter/material.dart';
import 'text_field.dart';


/// Widget de saisie + bouton + + listes de chips scrollable
class ChampTextList extends StatefulWidget {
  final String hint;
  const ChampTextList({Key? key, required this.hint}) : super(key: key);

  @override
  State<ChampTextList> createState() => _ChampTextListState();
}

class _ChampTextListState extends State<ChampTextList> {
  final _controller = TextEditingController();
  final List<String> _items = [];

  void _ajouterItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // On utilise ChampTexte AVEC suffix
        ChampTexte(
          hint: widget.hint,
          isLong: false,
          controller: _controller,
          suffix: Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              iconSize: 40,
              splashRadius: 20,
              onPressed: _ajouterItem,
            ),
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
                children: _items.map((item) => InputChip(
                  label: Text(item),
                  backgroundColor: Colors.deepPurple.withAlpha((0.1 * 255).round()),
                  onDeleted: () => setState(() => _items.remove(item)),
                )).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
