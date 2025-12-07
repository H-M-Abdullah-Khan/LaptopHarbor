class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CategoryModel(
      id: documentId,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }
}
