import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:steph_g_food/features/catalog/models/product_filter.dart';
import 'package:steph_g_food/features/catalog/providers/catalog_providers.dart';

class CatalogFilterBar extends ConsumerWidget {
  final List<String> categories;

  const CatalogFilterBar({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barre de recherche + Bouton de tri
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un plat...',
                  prefixIcon: const Icon(LucideIcons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  ref.read(productFilterProvider.notifier).state = filter
                      .copyWith(searchQuery: value);
                },
              ),
            ),
            const SizedBox(width: 8),

            // Menu déroulant de tri
            PopupMenuButton<ProductSortOption>(
              icon: const Icon(LucideIcons.arrowUpDown),
              tooltip: 'Trier par',
              onSelected: (option) {
                ref.read(productFilterProvider.notifier).state = filter
                    .copyWith(sortOption: option);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: ProductSortOption.nameAsc,
                  child: Text('Nom (A-Z)'),
                ),
                const PopupMenuItem(
                  value: ProductSortOption.priceAsc,
                  child: Text('Prix croissant'),
                ),
                const PopupMenuItem(
                  value: ProductSortOption.priceDesc,
                  child: Text('Prix décroissant'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Filtre par catégories (Chips défilables)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('Tous'),
                selected: filter.selectedCategory == null,
                onSelected: (_) {
                  ref.read(productFilterProvider.notifier).state = filter
                      .copyWith(clearCategory: true);
                },
              ),
              const SizedBox(width: 8),
              ...categories.map((category) {
                final isSelected = filter.selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      ref.read(productFilterProvider.notifier).state = filter
                          .copyWith(
                            selectedCategory: selected ? category : null,
                            clearCategory: !selected,
                          );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
