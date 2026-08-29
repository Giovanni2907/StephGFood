import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/core/theme/providers/shared_preferences_provider.dart';

class FavoritesRepository {
  final SharedPreferences _prefs;
  static const String _key = 'favorite_products_ids';

  FavoritesRepository(this._prefs);

  List<String> getFavorites() {
    return _prefs.getStringList(_key) ?? [];
  }

  Future<bool> saveFavorites(List<String> ids) async {
    return await _prefs.setStringList(_key, ids);
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesRepository(prefs);
});