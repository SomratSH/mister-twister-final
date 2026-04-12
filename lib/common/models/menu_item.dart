class MenuItem {
  final String id;
  final String title;
  final String description;
  final String image;
  final String price;
  final String category;
  MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}