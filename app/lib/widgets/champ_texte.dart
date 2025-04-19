import 'package:flutter/material.dart';

class ChampTexte extends StatelessWidget {
  final String hint;
  final bool isLong;

  const ChampTexte({required this.hint, required this.isLong});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLong ? 400 : 100,
      alignment: Alignment.center,
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
      child: TextField(
        maxLines: isLong ? 14 : 1,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
