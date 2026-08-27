import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/search_provider.dart';
import '../../catalog/widgets/product_card.dart';
import 'package:steph_g_food/features/catalog/widgets/category_selector.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final maxPrice = ref.watch(maxPriceFilterProvider);
    final productsAsync = ref.watch(productsListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Barre de recherche et filtres
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ de texte dynamique
                  TextField(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Rechercher un plat (ex: Burger, Pizza)...',
                      prefixIcon: const Icon(LucideIcons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(LucideIcons.x),
                              onPressed: () {
                                ref.read(searchQueryProvider.notifier).state = '';
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: ColorScheme.dark(primary: Theme.of(context).colorScheme.primary).primary.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CategorySelector(),
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
                      ref.read(maxPriceFilterProvider.notifier).state = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${searchResults.length} résultat(s) trouvé(s)',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Gestion des états Asynchrones et de la Liste de Résultats
          productsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Erreur : $err')),
            ),
            data: (_) {
              if (searchResults.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.searchX, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Aucun plat ne correspond à votre recherche.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ProductCard(
                          product: product,
                          isFavorite: false,
                          onFavoriteToggle: () {},
                        ),
                      );
                    },
                    childCount: searchResults.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}