import 'package:flutter/material.dart';
import 'add_list.dart';
import 'text_field.dart';


class StepPage extends StatelessWidget {
  final String title;
  final String hint;
  final bool isList;
  final bool isLongText;

  const StepPage({super.key, required this.title, required this.hint, this.isList = false,     this.isLongText = false,});

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
                  ? ChampTextList(hint: hint)
                  : ChampTexte(hint: hint, isLong: isLongText),

            ],
          ),
        ),
      ),
    );
  }
}
