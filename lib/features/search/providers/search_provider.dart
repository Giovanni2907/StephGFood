import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/catalog/services/product_repository.dart';
import '../../catalog/models/product.dart';

// 1. Providers de filtre
final searchQueryProvider = StateProvider<String>((ref) => '');
final maxPriceFilterProvider = StateProvider<double>((ref) => 1000000.0);
final selectedCategoryProvider = StateProvider<String>((ref) => 'Tous');

// 2. Provider de Tri
enum ProductSortOption { none, priceAsc, priceDesc, nameAsc }

final productSortOptionProvider = StateProvider<ProductSortOption>(
  (ref) => ProductSortOption.none,
);

// 3. FutureProvider chargé depuis le repository
final productsListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProducts();
});

// 4. Provider combiné qui conserve l'état AsyncValue (loading / data / error)
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsListProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final maxPrice = ref.watch(maxPriceFilterProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final sortOption = ref.watch(productSortOptionProvider);

  return productsAsync.whenData((products) {
    var result = products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory == 'Tous' || product.category == selectedCategory;

      final matchesPrice = product.price <= maxPrice;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    // Application du tri
    switch (sortOption) {
      case ProductSortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.none:
        break;
    }

    return result;
  });
});
