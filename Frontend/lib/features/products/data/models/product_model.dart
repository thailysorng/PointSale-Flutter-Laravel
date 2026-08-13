class Product {
  final String id;
  final String name;
  final String emoji;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.quantity = 0,
  });

  bool get isInCart => quantity > 0;

  Product copyWith({
    String? id,
    String? name,
    String? emoji,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
