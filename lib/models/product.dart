/// Product model class.
///
/// Demonstrates JSON serialization with [fromJson] and [toJson] methods,
/// matching Day 4 of the curriculum. No external packages are used —
/// only `dart:convert` (which is part of the Dart SDK).
class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final String imagePath;
  final String description;
  final double rating;
  final bool inStock;
  final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.inStock,
    this.quantity = 0,
  });

  Product copyWith({int? quantity}) => Product(
        id: id,
        name: name,
        price: price,
        category: category,
        imagePath: imagePath,
        description: description,
        rating: rating,
        inStock: inStock,
        quantity: quantity ?? this.quantity,
      );

  /// Creates a [Product] from a decoded JSON map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imagePath: json['imagePath'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      inStock: json['inStock'] as bool,
    );
  }

  /// Converts this [Product] back to a JSON-serializable map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'category': category,
        'imagePath': imagePath,
        'description': description,
        'rating': rating,
        'inStock': inStock,
      };

  /// Formatted price string with currency symbol (e.g. "1.299,90 ₺").
  String get formattedPrice {
    final whole = price.truncate();
    final cents = ((price - whole) * 100).round();
    final wholeStr = whole.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
        );
    return '$wholeStr,${cents.toString().padLeft(2, '0')} ₺';
  }
}
