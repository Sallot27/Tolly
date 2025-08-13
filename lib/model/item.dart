class ItemModel {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double deposit;
  final double pricePerDay;

  ItemModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.deposit,
    required this.pricePerDay,
  });
}
