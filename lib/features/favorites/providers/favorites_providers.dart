import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/favorites/data/favorites_repository.dart';

class FavoritesNotifier extends StateNotifier<List<String>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _repository.getFavorites();
  }

  Future<void> toggleFavorite(String productId) async {
    final updatedList = List<String>.from(state);
    if (updatedList.contains(productId)) {
      updatedList.remove(productId);
    } else {
      updatedList.add(productId);
    }
    state = updatedList;
    await _repository.saveFavorites(state);
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository);
});