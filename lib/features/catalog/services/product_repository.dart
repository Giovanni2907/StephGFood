import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/core/constants/app_assets.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';

// Provider synchrone pour SharedPreferences (surchargé dans main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'SharedPreferences doit être initialisé dans main.dart',
  );
});

// Provider du Repository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProductRepository(prefs);
});

// FutureProvider pour charger la liste initiale/persistée des produits
final productsListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

class ProductRepository {
  final SharedPreferences _prefs;
  static const String _productsKey = 'local_products_json_list';

  ProductRepository(this._prefs);

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

  Future<void> saveProducts(List<Product> products) async {
    final List<Map<String, dynamic>> jsonList = products
        .map((p) => p.toJson())
        .toList();
    final String jsonString = jsonEncode(jsonList);

    await _prefs.setString(_productsKey, jsonString);
  }

  Future<List<Product>> addProduct(Product newProduct) async {
    final currentProducts = await getProducts();
    final updatedList = [...currentProducts, newProduct];
    await saveProducts(updatedList);
    return updatedList;
  }

  Future<List<Product>> resetToInitialData() async {
    await clearProducts();
    return await getProducts();
  }

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
