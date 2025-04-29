class Dream {
  DateTime date;
  String title;
  String content;
  String feeling;
  List<String> actors;
  List<String> locations;
  List<String> tagsBeforeEvent;
  List<String> tagsBeforeFeeling;
  List<String> tagsDreamFeeling;

  Dream({
    required this.date,
    required this.title,
    required this.content,
    required this.feeling,
    required this.actors,
    required this.locations,
    required this.tagsBeforeEvent,
    required this.tagsBeforeFeeling,
    required this.tagsDreamFeeling,
  });


  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'feeling': feeling,
    'actors': actors,
    'locations': locations,
    'tagsBeforeEvent': tagsBeforeEvent,
    'tagsBeforeFeeling': tagsBeforeFeeling,
    'tagsDreamFeeling': tagsDreamFeeling,
  };


  factory Dream.fromJson(Map<String, dynamic> json) => Dream(
    date: DateTime.parse(json['date']),
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    feeling: json['feeling'] ?? '',
    actors: List<String>.from(json['actors'] ?? []),
    locations: List<String>.from(json['locations'] ?? []),
    tagsBeforeEvent: List<String>.from(json['tagsBeforeEvent'] ?? []),
    tagsBeforeFeeling: List<String>.from(json['tagsBeforeFeeling'] ?? []),
    tagsDreamFeeling: List<String>.from(json['tagsDreamFeeling'] ?? []),
  );
}
