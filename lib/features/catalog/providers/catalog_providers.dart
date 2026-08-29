import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';
import 'package:steph_g_food/features/catalog/models/product_filter.dart';
import 'package:steph_g_food/features/catalog/services/product_repository.dart';

// Provider d'état pour les critères de filtrage
final productFilterProvider = StateProvider<ProductFilter>((ref) {
  return const ProductFilter();
});

// FutureProvider pour charger tous les produits depuis le repository
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// Provider dérivé pour filtrer et trier la liste des produits en mémoire
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(allProductsProvider);
  final filter = ref.watch(productFilterProvider);

  return productsAsync.whenData((products) {
    var result = products.where((product) {
      // 1. Filtre par recherche texte
      final matchesSearch = product.name.toLowerCase().contains(
        filter.searchQuery.toLowerCase(),
      );

      // 2. Filtre par catégorie
      final matchesCategory =
          filter.selectedCategory == null ||
          product.category == filter.selectedCategory;

      // 3. Filtre par prix maximum
      final matchesPrice = product.price <= filter.maxPrice;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    // 4. Tri de la liste filtrée
    switch (filter.sortOption) {
      case ProductSortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return result;
  });
});
