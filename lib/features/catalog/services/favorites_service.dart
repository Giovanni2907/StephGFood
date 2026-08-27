import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorite_products_ids';

  // Charger la liste des IDs favoris
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Basculer l'état favori (ajouter ou retirer)
  static Future<bool> toggleFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_key) ?? [];

    bool isFav;
    if (favorites.contains(productId)) {
      favorites.remove(productId);
      isFav = false;
    } else {
      favorites.add(productId);
      isFav = true;
    }

    await prefs.setStringList(_key, favorites);
    return isFav;
  }
}