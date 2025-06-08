import 'package:flutter/material.dart';
import '../models/app_front_parameters.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isLong ? BorderRadius.circular(16) : BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(AppFrontParameters.redactionFieldShadow),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: isLong ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: isLong
                ? ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150, maxHeight: 300),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: TextField(
                    onChanged: onChanged,
                    controller: effectiveController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            )
                : TextField(
              onChanged: onChanged,
              controller: effectiveController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
