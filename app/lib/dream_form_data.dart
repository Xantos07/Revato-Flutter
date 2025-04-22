import '../models/dream.dart';

class DreamFormData {
  String title;
  List<String> actors;
  List<String> locations;
  String content;
  String feeling;
  List<String> tagsBeforeEvent;
  List<String> tagsBeforeFeeling;
  List<String> tagsDreamFeeling;

  DreamFormData({
    required this.title,
    required this.actors,
    required this.locations,
    required this.content,
    required this.feeling,
    required this.tagsBeforeEvent,
    required this.tagsBeforeFeeling,
    required this.tagsDreamFeeling,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "actors": actors,
      "locations": locations,
      "content": content,
      "feeling": feeling,
      "tagsBeforeEvent": tagsBeforeEvent,
      "tagsBeforeFeeling": tagsBeforeFeeling,
      "tagsDreamFeeling": tagsDreamFeeling,
    };
  }

  Dream toDream() {
    return Dream(
      title: title,
      content: content,
      feeling: feeling,
      actors: actors,
      locations: locations,
    );
  }
}
