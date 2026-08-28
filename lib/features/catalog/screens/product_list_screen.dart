import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/catalog/providers/favorites_notifier.dart';
import 'package:steph_g_food/features/search/providers/search_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Écoute dynamique de la liste filtrée/triée (AsyncValue<List<Product>>)
    final productsAsync = ref.watch(filteredProductsProvider);

    // 2. Écoute réactive de la liste des favoris (Set<String>)
    final favoriteIds = ref.watch(favoritesNotifierProvider);

    return Scaffold(
      body: productsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Erreur : $error'),
        ),
        data: (products) {
          // Si la liste filtrée est vide
          if (products.isEmpty) {
            return const Center(
              child: Text('Aucun produit disponible'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              final isFav = favoriteIds.contains(product.id);

              return ProductCard(
                product: product,
                isFavorite: isFav,
                onFavoriteToggle: () {
                  // Action réactive via le Notifier Riverpod (avec persistance)
                  ref
                      .read(favoritesNotifierProvider.notifier)
                      .toggleFavorite(product.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}