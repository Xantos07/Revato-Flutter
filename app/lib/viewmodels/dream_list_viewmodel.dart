import 'package:flutter/material.dart';
import '../../models/dream.dart';
import '../../controller/dream_controller.dart';

class DreamListViewModel extends ChangeNotifier {
  final DreamController _controller = DreamController();

  List<Dream>? _cachedDreams;

  Future<List<Dream>> _fetchAllDreams() async {
    if (_cachedDreams != null) return _cachedDreams!;
    final dreams = await _controller.getDreams();
    _cachedDreams = dreams;
    return dreams;
  }

  Future<List<Dream>> getAllDreams() async {
    return _fetchAllDreams();
  }

  Future<Map<DateTime, List<Dream>>> getGroupedDreams({
    List<String>? selectedTags,
    DateTime? selectedDate,
  }) async {
    final dreams = await _fetchAllDreams();

    final filtered = dreams.where((dream) {
      final matchTags = selectedTags == null || selectedTags.every((tag) =>
      dream.tagsBeforeEvent.contains(tag) ||
          dream.tagsBeforeFeeling.contains(tag) ||
          dream.tagsDreamFeeling.contains(tag));

      final matchDate = selectedDate == null ||
          DateUtils.isSameDay(dream.date, selectedDate);

      return matchTags && matchDate;
    }).toList();

    return _groupByDate(filtered);
  }

  Map<DateTime, List<Dream>> _groupByDate(List<Dream> dreams) {
    final map = <DateTime, List<Dream>>{};
    for (var d in dreams) {
      final day = DateTime(d.date.year, d.date.month, d.date.day);
      map.putIfAbsent(day, () => []).add(d);
    }
    return map;
  }

  List<Dream> _allDreams = [];

  Future<void> loadInitialDreams() async {
    try {
      final dreams = await getDreamsByPage(1, 10);
      _cachedDreams = dreams;
    } catch (e) {

      print('Erreur lors du chargement initial des rêves : $e');
    }
  }
  List<Dream> get allDreams => _allDreams;

  Future<List<Dream>> getDreamsByPage(int page, int pageSize, [List<String>? tags, DateTimeRange? dateRange]) async {
    return await _controller.getDreamsByPage(page, pageSize, tags, dateRange);
  }

}