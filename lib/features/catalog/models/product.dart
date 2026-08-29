import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String image;
  final bool isAvailable;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    this.isAvailable = true,
    this.rating = 4.5,
  });

  /// Résout le chemin de l'image (prend en compte les assets locaux et URLs distantes)
  String get imagePath {
    if (image.isEmpty) return 'assets/images/placeholder.png';
    if (image.startsWith('http://') || image.startsWith('https://')) return image;
    if (image.startsWith('assets/')) return image;
    return 'assets/images/$image';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      image: json['image'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'isAvailable': isAvailable,
      'rating': rating,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? image,
    bool? isAvailable,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.category == category &&
        other.image == image &&
        other.isAvailable == isAvailable &&
        other.rating == rating;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      price,
      category,
      image,
      isAvailable,
      rating,
    );
  }
}