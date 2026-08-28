import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';
import 'package:steph_g_food/features/search/providers/search_provider.dart';

void main() {
  // Mock data avec des prix ajustés (< 30.0 pour correspondre au maxPriceFilterProvider par défaut)
  final mockProducts = [
    const Product(id: '1', name: 'Cheeseburger', category: 'Burger', price: 15.0, description: '', image: ''),
    const Product(id: '2', name: 'Pizza Margherita', category: 'Pizza', price: 20.0, description: '', image: ''),
    const Product(id: '3', name: 'Chicken Burger', category: 'Burger', price: 18.0, description: '', image: ''),
    const Product(id: '4', name: 'Tacos Supreme', category: 'Tacos', price: 25.0, description: '', image: ''),
  ];

  // Helper pour créer un ProviderContainer pré-configuré avec l'écouteur réactif
  Future<ProviderContainer> createContainer({
    List<Product>? products,
  }) async {
    final container = ProviderContainer(
      overrides: [
        productsListProvider.overrideWith((ref) async => products ?? mockProducts),
      ],
    );
    container.listen(filteredProductsProvider, (_, __) {});
    await container.read(productsListProvider.future);
    return container;
  }

  group('Tests Unitaires - filteredProductsProvider (Filtres de base)', () {
    test('Retourne tous les produits si aucun filtre n\'est appliqué', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      final result = container.read(filteredProductsProvider);
      expect(result.value, equals(mockProducts));
    });

    test('Filtre correctement par recherche textuelle (insensible à la casse)', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'pizza';

      final result = container.read(filteredProductsProvider);
      expect(result.value?.length, 1);
      expect(result.value?.first.name, 'Pizza Margherita');
    });

    test('Filtre correctement par catégorie', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(selectedCategoryProvider.notifier).state = 'Burger';

      final result = container.read(filteredProductsProvider);
      expect(result.value?.length, 2);
      expect(result.value?.every((p) => p.category == 'Burger'), isTrue);
    });

    test('Filtre correctement par prix maximum', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(maxPriceFilterProvider.notifier).state = 19.0;

      final result = container.read(filteredProductsProvider);
      expect(result.value?.length, 2); // Cheeseburger (15.0) et Chicken Burger (18.0)
      expect(result.value?.every((p) => p.price <= 19.0), isTrue);
    });
  });

  group('Tests Unitaires - filteredProductsProvider (Tri)', () {
    test('Trie correctement par prix croissant (priceAsc)', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(productSortOptionProvider.notifier).state = ProductSortOption.priceAsc;

      final result = container.read(filteredProductsProvider).value;
      expect(result?.map((p) => p.price).toList(), [15.0, 18.0, 20.0, 25.0]);
    });

    test('Trie correctement par prix décroissant (priceDesc)', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(productSortOptionProvider.notifier).state = ProductSortOption.priceDesc;

      final result = container.read(filteredProductsProvider).value;
      expect(result?.map((p) => p.price).toList(), [25.0, 20.0, 18.0, 15.0]);
    });

    test('Trie correctement par nom alphabétique (nameAsc)', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(productSortOptionProvider.notifier).state = ProductSortOption.nameAsc;

      final result = container.read(filteredProductsProvider).value;
      expect(
        result?.map((p) => p.name).toList(),
        ['Cheeseburger', 'Chicken Burger', 'Pizza Margherita', 'Tacos Supreme'],
      );
    });
  });

  group('Tests Unitaires - filteredProductsProvider (Cas Limites / Edge Cases)', () {
    test('Retourne une liste vide lorsqu\'aucun produit ne correspond à la recherche', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'Sushi';

      final result = container.read(filteredProductsProvider);
      expect(result.value, isEmpty);
    });

    test('Combinaison simultanée de recherche, catégorie et prix max', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'Burger';
      container.read(selectedCategoryProvider.notifier).state = 'Burger';
      container.read(maxPriceFilterProvider.notifier).state = 16.0;

      final result = container.read(filteredProductsProvider).value;
      expect(result?.length, 1);
      expect(result?.first.name, 'Cheeseburger');
    });

    test('Gère correctement une liste de produits initiale vide', () async {
      final container = await createContainer(products: []);
      addTearDown(container.dispose);

      final result = container.read(filteredProductsProvider);
      expect(result.value, isEmpty);
    });

    test('Le filtre par catégorie "Tous" ne masque aucun produit', () async {
      final container = await createContainer();
      addTearDown(container.dispose);

      container.read(selectedCategoryProvider.notifier).state = 'Tous';

      final result = container.read(filteredProductsProvider).value;
      expect(result?.length, mockProducts.length);
    });
  });
}