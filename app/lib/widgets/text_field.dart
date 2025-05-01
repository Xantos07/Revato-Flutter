import 'package:flutter/material.dart';

/// Champ texte stylé, avec option de suffix widget (bouton, icône…)
class ChampTexte extends StatelessWidget {
  final String hint;
  final bool isLong;
  final String? initialValue;
  final TextEditingController? controller;
  final Widget? suffix;
  final void Function(String)? onChanged;


  const ChampTexte({
    Key? key,
    required this.hint,
    required this.isLong,
    this.initialValue,
    this.controller,
    this.suffix,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final effectiveController = controller ?? TextEditingController(text: initialValue ?? '');


    return Container(
      height: isLong ? 400 : 75,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: effectiveController,
              maxLines: isLong ? 14 : 1,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),

          // Si on a passé un suffix, on l'affiche dedans :
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
