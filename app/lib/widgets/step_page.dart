import 'package:flutter/material.dart';
import 'champ_text_list.dart';
import 'text_field.dart';


class StepPage extends StatelessWidget {
  final String title;
  final String hint;
  final bool isList;
  final bool isLongText;
  final void Function(String)? onChanged;
  final void Function(List<String>)? onListChanged;
  final String? initialValue;
  final List<String> initialList;
  final Color? chipColor;

  const StepPage({super.key, required this.title, required this.hint, this.isList = false,
    this.isLongText = false,this.onChanged, this.onListChanged, this.initialValue,     this.initialList = const [],this.chipColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),


              const SizedBox(height: 24),
              isList
                  ? ChampTextList(hint: hint,initialList: initialList, onListChanged: onListChanged,   chipColor: chipColor ?? Colors.deepPurple)
                  : ChampTexte(hint: hint, initialValue: initialValue, isLong: isLongText,onChanged: onChanged),

            ],
          ),
        ),
      ),
    );
  }
}
