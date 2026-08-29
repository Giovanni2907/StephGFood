import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steph_g_food/features/catalog/providers/favorites_notifier.dart';
import 'package:steph_g_food/core/theme/providers/shared_preferences_provider.dart';

void main() {
  test(
    'FavoritesNotifier restaure les favoris sauvegardés au démarrage',
    () async {
      // 1. Mock de SharedPreferences avec des valeurs initiales
      SharedPreferences.setMockInitialValues({
        'user_favorites': ['prod_1', 'prod_2'],
      });
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      // 2. Vérification que l'état initial lit les SharedPreferences
      final favorites = container.read(favoritesNotifierProvider);
      expect(favorites, containsAll(['prod_1', 'prod_2']));
    },
  );

  test(
    'toggleFavorite sauvegarde les modifications dans SharedPreferences',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      // Act
      await container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite('prod_99');

      // Assert (en mémoire et dans les prefs)
      expect(container.read(favoritesNotifierProvider), contains('prod_99'));
      expect(prefs.getStringList('user_favorites'), equals(['prod_99']));
    },
  );
}
