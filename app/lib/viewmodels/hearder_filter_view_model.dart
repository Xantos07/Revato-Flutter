// header_filter_view_model.dart
import 'package:flutter/material.dart';
import '../models/tag_model.dart';
import '../controller/tag_controller.dart';

class HeaderFilterViewModel {
  final TagController tagController = TagController();

  DateTimeRange? selectedDateRange;
  String filterMode = 'OU';
  List<String> selectedTags = [];

  void toggleFilterMode() {
    filterMode = filterMode == 'OU' ? 'ET' : 'OU';
  }

  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
    }
  }

  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  void updateDateRange(DateTimeRange? range) {
    selectedDateRange = range;
  }

  void clearDate() {
    selectedDateRange = null;
  }

  Future<List<TagModel>> fetchSelectedTags(List<String> tagNames) async {
    final all = await fetchTagsPaginated(
      page: 1,
      pageSize: 10,
    );
    return all.where((tag) => tagNames.contains(tag.name)).toList();
  }

  Future<List<TagModel>> fetchTagsPaginated({
    required int page,
    required int pageSize,
    String? category,
    String? search,
  }) {
    return tagController.fetchTagsPaginated(
      page: page,
      pageSize: pageSize,
      category: category,
      search: search,
    );
  }
}
