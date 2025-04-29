import '../models/dream.dart';

class DreamFormData {
  DateTime date;
  String title;
  List<String> actors;
  List<String> locations;
  String content;
  String feeling;
  List<String> tagsBeforeEvent;
  List<String> tagsBeforeFeeling;
  List<String> tagsDreamFeeling;

  DreamFormData({
    required this.date,
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
      "date": date,
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
      date: date,
      title: title,
      content: content,
      feeling: feeling,
      actors: actors,
      locations: locations,
      tagsBeforeEvent: tagsBeforeEvent,
      tagsBeforeFeeling: tagsBeforeFeeling,
      tagsDreamFeeling: tagsDreamFeeling,
    );
  }
}
