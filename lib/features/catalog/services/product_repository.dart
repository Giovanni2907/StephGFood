import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/core/constants/app_assets.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';

class ProductRepository {
  static const String _productsKey = 'local_products_json_list';

  static Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJsonString = prefs.getString(_productsKey);

    if (productsJsonString == null || productsJsonString.isEmpty) {
      final initialProducts = _getInitialDummyData();
      await saveProducts(initialProducts);
      return initialProducts;
    }

    final List<dynamic> jsonList = jsonDecode(productsJsonString);
    return jsonList.map((item) => Product.fromJson(item)).toList();
  }

  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList =
        products.map((p) => p.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);

    await prefs.setString(_productsKey, jsonString);
  }

  static Future<List<Product>> addProduct(Product newProduct) async {
    final currentProducts = await getProducts();
    final updatedList = [...currentProducts, newProduct];
    await saveProducts(updatedList);
    return updatedList;
  }

  // Méthode pour forcer la réinitialisation du cache lors du dev
  static Future<List<Product>> resetToInitialData() async {
    await clearProducts();
    return await getProducts();
  }

  static Future<void> clearProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
  }

  // 1. Identifiants et noms distincts pour chaque produit
  static List<Product> _getInitialDummyData() {
    return [
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