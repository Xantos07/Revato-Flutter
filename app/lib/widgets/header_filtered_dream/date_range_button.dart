import 'package:flutter/material.dart';
import '../../viewmodels/hearder_filter_view_model.dart';

class DateRangeButton extends StatelessWidget {
  final HeaderFilterViewModel viewModel;
  final ValueChanged<DateTimeRange?> onDateRangePicked;

  const DateRangeButton({
    Key? key,
    required this.viewModel,
    required this.onDateRangePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          initialDateRange: viewModel.selectedDateRange,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialEntryMode: DatePickerEntryMode.input,
          builder: (ctx, child) {
            return Theme(
              data: Theme.of(ctx).copyWith(
                dialogBackgroundColor: Colors.white,
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(ctx).copyWith(scrollbars: false),
                child: child!,
              ),
            );
          },
        );
        if (picked != null) {
          print('📅 Date sélectionnée dans DateRangeButton : $picked');
        } else {
          print('📅 Sélection annulée dans DateRangeButton');
        }
        onDateRangePicked(picked);
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: const BorderSide(color: Colors.deepPurple),
      ),
      child: Text(
        _formatRangeMultiLine(viewModel.selectedDateRange),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  String _formatRangeMultiLine(DateTimeRange? range) {
    if (range == null) return 'Aucune date';
    final start = "${range.start.day}/${range.start.month}/${range.start.year}";
    final end = "${range.end.day}/${range.end.month}/${range.end.year}";
    return "$start\n$end";
  }
}
