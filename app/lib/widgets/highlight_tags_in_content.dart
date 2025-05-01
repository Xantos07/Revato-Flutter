import 'package:flutter/cupertino.dart';

import '../models/app_colors.dart';
import '../models/dream.dart';

List<TextSpan> highlightTagsInContent(String content, Dream dream) {
  final allTags = {
    for (var tag in dream.tagsBeforeEvent) tag: AppColors.previousEvent,
    for (var tag in dream.tagsBeforeFeeling) tag: AppColors.previousFeeling,
    for (var tag in dream.tagsDreamFeeling) tag: AppColors.dreamFeeling,
  };

  final words = content.split(' ');

  return words.map((word) {
    final cleanWord = word.replaceAll(RegExp(r'[^\w]'), ''); // nettoie ponctuation
    final color = allTags[cleanWord];
    if (color != null) {
      return TextSpan(
        text: "$word ",
        style: TextStyle(backgroundColor: color.withOpacity(0.3), color: color),
      );
    } else {
      return TextSpan(text: "$word ");
    }
  }).toList();
}
