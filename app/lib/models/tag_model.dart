class TagModel {
  final String name;
  final String category;

  TagModel({required this.name, required this.category});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
