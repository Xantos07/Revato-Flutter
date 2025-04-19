import 'package:flutter/material.dart';

class ListeAvecAjout extends StatefulWidget {
  final String hint;
  const ListeAvecAjout({super.key, required this.hint});

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
              Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  iconSize: 32,
                  splashRadius: 32,
                  onPressed: _ajouterItem,
                ),
              )
            ],
          ),
        ),
        if (_items.isNotEmpty) ...[
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _items
                .map((item) => Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 4),
              child: Text("• $item", style: const TextStyle(fontStyle: FontStyle.italic)),
            ))
                .toList(),
          )
        ]
      ],
    );
  }
}
