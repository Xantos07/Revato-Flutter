// lib/viewmodels/dream_list_viewmodel.dart

import '../../models/dream.dart';
import '../../controller/dream_controller.dart';

class DreamListViewModel {
  final DreamController _controller = DreamController();

  Future<Map<DateTime, List<Dream>>> getGroupedDreams() async {
    final dreams = await _controller.getDreams();
    return _groupByDate(dreams);
  }

  Map<DateTime, List<Dream>> _groupByDate(List<Dream> dreams) {
    final map = <DateTime, List<Dream>>{};
    for (var d in dreams) {
      final day = DateTime(d.date.year, d.date.month, d.date.day);
      map.putIfAbsent(day, () => []).add(d);
    }
    return map;
  }
}
