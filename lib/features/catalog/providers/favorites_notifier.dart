import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/features/catalog/services/product_repository.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final SharedPreferences _prefs;
  static const _key = 'user_favorites';

  FavoritesNotifier(this._prefs) : super({}) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final savedFavorites = _prefs.getStringList(_key);
    if (savedFavorites != null) {
      state = savedFavorites.toSet();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final newState = Set<String>.from(state);
    if (newState.contains(productId)) {
      newState.remove(productId);
    } else {
      newState.add(productId);
    }
    state = newState;
    await _prefs.setStringList(_key, state.toList());
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});