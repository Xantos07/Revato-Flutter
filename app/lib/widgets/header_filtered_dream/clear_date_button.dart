import 'package:flutter/material.dart';

class ClearDateButton extends StatelessWidget {
  final VoidCallback onClear;

  const ClearDateButton({Key? key, required this.onClear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClear,
      icon: const Icon(Icons.close),
      tooltip: "Réinitialiser la date",
    );
  }
}
