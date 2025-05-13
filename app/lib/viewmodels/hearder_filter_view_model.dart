import 'package:flutter/material.dart';

import '../controller/tag_controller.dart';
import '../models/tag_model.dart';

class HeaderFilterViewModel {
  DateTimeRange? selectedDateRange;
  String filterMode = 'OU';
  List<String> selectedTags = [];

  final TagController _tagController = TagController();

  Future<List<TagModel>> fetchTags() async {
    return await _tagController.fetchUserTags();
  }

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
}
