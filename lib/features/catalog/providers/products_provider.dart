import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return const [
    Product(
      id: '1',
      name: 'Burger StephG Spécial',
      description:
          'Double steak haché, fromage cheddar fondu, sauce maison StephG et condiments frais.',
      price: 12.50,
      category: 'Burger',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
      rating: 4.8,
    ),
    Product(
      id: '2',
      name: 'Pizza Pepperoni Supreme',
      description:
          'Sauce tomate artisanale, mozzarella fondante et généreuses tranches de pepperoni.',
      price: 15.00,
      category: 'Pizza',
      image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e',
      rating: 4.6,
    ),
    Product(
      id: '3',
      name: 'Tacos Poulet Pané',
      description:
          'Tortilla garnie de poulet croustillant, frites, sauce fromagère onctueuse.',
      price: 9.90,
      category: 'Tacos',
      image: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47',
      rating: 4.7,
    ),
  ];
});

// Provider pour filtrer par catégorie
final selectedCategoryProvider = StateProvider<String>((ref) => 'Tous');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final category = ref.watch(selectedCategoryProvider);

  if (category == 'Tous') return products;
  return products.where((p) => p.category == category).toList();
});
