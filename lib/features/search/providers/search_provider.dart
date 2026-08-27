import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/catalog/services/product_repository.dart';
import '../../catalog/models/product.dart';

// Provider du texte de recherche
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider du prix maximum
final maxPriceFilterProvider = StateProvider<double>((ref) => 30.0);

// Provider de la catégorie sélectionnée ('Tous', 'Burger', 'Pizza', etc.)
final selectedCategoryProvider = StateProvider<String>((ref) => 'Tous');

// FutureProvider pour lire la liste des produits depuis le Repository
final productsListProvider = FutureProvider<List<Product>>((ref) async {
  return await ProductRepository.getProducts();
});

// Provider combiné : applique les 3 filtres dynamiquement
final searchResultsProvider = Provider<List<Product>>((ref) {
  final productsAsync = ref.watch(productsListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final maxPrice = ref.watch(maxPriceFilterProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return productsAsync.maybeWhen(
    data: (products) {
      return products.where((product) {
        // 1. Filtre par recherche textuelle (Nom ou Description)
        final matchesQuery = query.isEmpty ||
            product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);

        // 2. Filtre par prix max
        final matchesPrice = product.price <= maxPrice;

        // 3. Filtre par catégorie
        final matchesCategory = selectedCategory == 'Tous' ||
            product.category.toLowerCase() == selectedCategory.toLowerCase();

        return matchesQuery && matchesPrice && matchesCategory;
      }).toList();
    },
    orElse: () => [],
  );
});