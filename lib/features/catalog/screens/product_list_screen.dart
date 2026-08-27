import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/catalog/providers/favorites_notifier.dart';
import 'package:steph_g_food/features/search/providers/search_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Écoute dynamique de la liste des produits filtrés et triés
    final products = ref.watch(searchResultsProvider);
    
    // 2. Écoute réactive de la liste des favoris
    final favoriteIds = ref.watch(favoritesNotifierProvider);
    
    // 3. Écoute de l'état de chargement initial des produits
    final productsAsync = ref.watch(productsListProvider);

    return Scaffold(
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur : $error')),
        data: (_) {
          if (products.isEmpty) {
            return const Center(child: Text('Aucun produit disponible'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
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
          );
        },
      ),
    );
  }
}