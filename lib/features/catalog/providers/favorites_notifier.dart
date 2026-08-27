import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/features/catalog/services/product_repository.dart';

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final SharedPreferences _prefs;
  static const String _favoritesKey = 'user_favorite_product_ids';

  FavoritesNotifier(this._prefs) : super({}) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final List<String>? savedFavorites = _prefs.getStringList(_favoritesKey);
    if (savedFavorites != null) {
      state = savedFavorites.toSet();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final updatedState = Set<String>.from(state);
    if (updatedState.contains(productId)) {
      updatedState.remove(productId);
    } else {
      updatedState.add(productId);
    }
    
    state = updatedState;
    await _prefs.setStringList(_favoritesKey, state.toList());
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}