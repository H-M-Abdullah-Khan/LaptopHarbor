class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;

  BrandModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BrandModel(
      id: documentId,
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'],
    );
  }
}
