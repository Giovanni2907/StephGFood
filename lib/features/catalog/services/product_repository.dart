import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/core/constants/app_assets.dart';
import 'package:steph_g_food/core/theme/providers/shared_preferences_provider.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';

// -----------------------------------------------------------------------------
// 1. Interface Abstraite du Repository (Clean Architecture)
// -----------------------------------------------------------------------------
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<void> saveProducts(List<Product> products);
  Future<List<Product>> addProduct(Product newProduct);
  Future<List<Product>> resetToInitialData();
  Future<void> clearProducts();
}

// -----------------------------------------------------------------------------
// 2. Implémentation Concrète avec SharedPreferences
// -----------------------------------------------------------------------------
class ProductRepositoryImpl implements ProductRepository {
  final SharedPreferences _prefs;
  static const String _productsKey = 'local_products_json_list';

  ProductRepositoryImpl(this._prefs);

  @override
  Future<List<Product>> getProducts() async {
    final String? productsJsonString = _prefs.getString(_productsKey);

    if (productsJsonString == null || productsJsonString.isEmpty) {
      final initialProducts = _getInitialDummyData();
      await saveProducts(initialProducts);
      return initialProducts;
    }

    final List<dynamic> jsonList = jsonDecode(productsJsonString);
    return jsonList.map((item) => Product.fromJson(item)).toList();
  }

  @override
  Future<void> saveProducts(List<Product> products) async {
    final List<Map<String, dynamic>> jsonList =
        products.map((p) => p.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);

    await _prefs.setString(_productsKey, jsonString);
  }

  @override
  Future<List<Product>> addProduct(Product newProduct) async {
    final currentProducts = await getProducts();
    final updatedList = [...currentProducts, newProduct];
    await saveProducts(updatedList);
    return updatedList;
  }

  @override
  Future<List<Product>> resetToInitialData() async {
    await clearProducts();
    return await getProducts();
  }

  @override
  Future<void> clearProducts() async {
    await _prefs.remove(_productsKey);
  }

  static List<Product> _getInitialDummyData() {
    return const [
      Product(
        id: '1',
        name: 'Burger Classique',
        description: 'Un délicieux burger avec du fromage et des tomates.',
        price: 9.99,
        category: 'Burger',
        image: AppAssets.burger,
      ),
      Product(
        id: '2',
        name: 'Pizza Margherita',
        description: 'Une pizza traditionnelle à la mozzarella.',
        price: 5.99,
        category: 'Pizza',
        image: AppAssets.pizza,
      ),
      Product(
        id: '3',
        name: 'Double Cheeseburger',
        description: 'Double portion de viande hachée et cheddar fondu.',
        price: 12.99,
        category: 'Burger',
        image: AppAssets.burger,
      ),
      Product(
        id: '4',
        name: 'Pizza Quatre Fromages',
        description: 'Mélange savoureux de 4 fromages italiens.',
        price: 8.99,
        category: 'Pizza',
        image: AppAssets.pizza,
      ),
    ];
  }
}

// -----------------------------------------------------------------------------
// 3. Providers Riverpod
// -----------------------------------------------------------------------------

/// Provider injectant l'implémentation du repository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProductRepositoryImpl(prefs);
});

/// FutureProvider pour la liste brute initiale/persistée
final productsListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// -----------------------------------------------------------------------------
// 4. Providers de Filtrage, Recherche et Tri (Problème 3)
// -----------------------------------------------------------------------------

enum SortOption { priceAsc, priceDesc, nameAsc, ratingDesc }

/// Provider pour la recherche textuelle
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider pour la catégorie sélectionnée
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Provider pour le critère de tri actuel
final sortByProvider = StateProvider<SortOption>((ref) => SortOption.nameAsc);

/// Provider réactif combinant la liste originale avec recherche, filtre et tri
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsListProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim().toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final sortBy = ref.watch(sortByProvider);

  return productsAsync.whenData((products) {
    // 1. Filtrage par recherche et par catégorie
    final filtered = products.where((product) {
      final matchesSearch = searchQuery.isEmpty ||
          product.name.toLowerCase().contains(searchQuery) ||
          product.description.toLowerCase().contains(searchQuery);

      final matchesCategory = selectedCategory == null ||
          selectedCategory.isEmpty ||
          product.category.toLowerCase() == selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    // 2. Application du tri
    switch (sortBy) {
      case SortOption.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.nameAsc:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.ratingDesc:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  });
});