class Dream {
  String title;
  String content;
  String feeling;
  List<String> actors;
  List<String> locations;

  Dream({
    required this.title,
    required this.content,
    required this.feeling,
    required this.actors,
    required this.locations,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'feeling': feeling,
    'actors': actors,
    'locations': locations,
  };
}
