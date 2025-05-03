import 'package:flutter/material.dart';
import 'text_field.dart';

/// Widget de saisie + bouton + listes de chips scrollable
class ChampTextList extends StatefulWidget {
  final String hint;
  final void Function(List<String>)? onListChanged;
  final List<String> initialList;
  final Color chipColor;

  const ChampTextList({
    Key? key,
    required this.hint,
    this.onListChanged,
    this.initialList = const [],
    this.chipColor = Colors.deepPurple,

  }) : super(key: key);

  @override
  State<ChampTextList> createState() => _ChampTextListState();
}

class _ChampTextListState extends State<ChampTextList> {
  final _controller = TextEditingController();
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialList);
  }

  void _ajouterItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(text);
      _controller.clear();
    });
    widget.onListChanged?.call(_items);
  }

  void _supprimerItem(String item) {
    setState(() {
      _items.remove(item);
    });
    widget.onListChanged?.call(_items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChampTexte(
          hint: widget.hint,
          isLong: false,
          controller: _controller,
          suffix: Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: widget.chipColor,
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
                children: _items.map((item) => Chip(
                  label: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: widget.chipColor,
                  deleteIconColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.white),
                  onDeleted: () => _supprimerItem(item),
                )).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
