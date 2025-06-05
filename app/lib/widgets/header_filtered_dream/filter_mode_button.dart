import 'package:flutter/material.dart';
import '../../viewmodels/hearder_filter_view_model.dart';

/// Bouton qui affiche le mode de filtre
class FilterModeButton extends StatelessWidget {
  final HeaderFilterViewModel viewModel;
  final VoidCallback onToggle;

  const FilterModeButton({
    Key? key,
    required this.viewModel,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onToggle,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Text(viewModel.filterMode),
    );
  }
}
