import 'package:flutter/material.dart';

class AddTagButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddTagButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepPurple,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.add, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}