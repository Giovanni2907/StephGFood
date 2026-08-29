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

  // Conversion depuis JSON (utile quand vous brancherez l'API FastAPI plus tard)
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

  // Conversion vers JSON
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

  // Copie d'objet pour immutabilité
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
}
