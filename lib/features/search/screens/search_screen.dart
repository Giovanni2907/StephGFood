import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';
import 'package:steph_g_food/features/catalog/providers/favorites_notifier.dart';
import 'package:steph_g_food/features/catalog/providers/products_provider.dart';
import 'package:steph_g_food/features/catalog/widgets/catalog_filter_bar.dart';
import '../providers/search_provider.dart' hide filteredProductsProvider;
import '../../catalog/widgets/product_card.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
Widget build(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);

  // 1. Récupération des états depuis Riverpod
  final maxPrice = ref.watch(maxPriceFilterProvider);
  final favoriteIds = ref.watch(favoritesNotifierProvider);
  final allProductsAsync = ref.watch(productsListProvider);
  
  // 2. Écoute du provider filtré (Typé en AsyncValue<List<Product>>)
  final AsyncValue<List<Product>> productsAsync = ref.watch(filteredProductsProvider as ProviderListenable<AsyncValue<List<Product>>>);

final List<String> categories = allProductsAsync.maybeWhen(
    data: (products) {
      final uniqueCategories = products.map((p) => p.category).toSet().toList();
      return ['Tous', ...uniqueCategories];
    },
    orElse: () => ['Tous'],
  );
  return Scaffold(
    body: SafeArea(
      child: CustomScrollView(
        slivers: [
          // En-tête : Filtres et Slider de prix
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CatalogFilterBar(categories: categories),
                  const SizedBox(height: 16),

                  // Filtre par Prix Maximum
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix max :',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${maxPrice.toStringAsFixed(2)} €',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: maxPrice,
                    min: 5.0,
                    max: 30.0,
                    divisions: 25,
                    label: '${maxPrice.toStringAsFixed(1)} €',
                    activeColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      ref
                          .read(maxPriceFilterProvider.notifier)
                          .state = value;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Nombre de résultats
                  productsAsync.maybeWhen(
                    data: (products) => Text(
                      '${products.length} résultat(s) trouvé(s)',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          // Grille de produits sous forme de Sliver
          productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.searchX,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aucun produit ne correspond à vos critères',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      final isFav = favoriteIds.contains(product.id);

                      return ProductCard(
                        product: product,
                        isFavorite: isFav,
                        onFavoriteToggle: () {
                          ref
                              .read(favoritesNotifierProvider.notifier)
                              .toggleFavorite(product.id);
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stackTrace) => SliverFillRemaining(
              child: Center(
                child: Text('Erreur lors du chargement : $error'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}