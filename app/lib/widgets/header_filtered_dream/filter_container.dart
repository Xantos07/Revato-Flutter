import 'package:flutter/material.dart';
import '../../models/tag_model.dart';
import 'filter_mode_button.dart';
import 'date_range_button.dart';
import 'clear_date_button.dart';
import 'add_tag_button.dart';
import '../../viewmodels/hearder_filter_view_model.dart';

class FilterContainer extends StatelessWidget {
  final HeaderFilterViewModel viewModel;
  final List<String> selectedTags;
  final List<TagModel> allTags;
  final ValueChanged<DateTimeRange?> onDateRangePicked;
  final VoidCallback onToggleFilterMode;
  final VoidCallback onClearDate;
  final VoidCallback onOpenTagSelector;
  final Function(String) onTagRemoved;
  final Function(List<String>, DateTimeRange?) onFilterChanged;

  const FilterContainer({
    Key? key,
    required this.viewModel,
    required this.selectedTags,
    required this.allTags,
    required this.onDateRangePicked,
    required this.onToggleFilterMode,
    required this.onClearDate,
    required this.onOpenTagSelector,
    required this.onTagRemoved,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterModeButton(
            viewModel: viewModel,
            onToggle: onToggleFilterMode,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DateRangeButton(
              viewModel: viewModel,
              onDateRangePicked: onDateRangePicked,
            ),
          ),
          ClearDateButton(onClear: onClearDate),
          const SizedBox(width: 8),
          AddTagButton(onTap: onOpenTagSelector),
        ],
      ),
    );
  }
}
