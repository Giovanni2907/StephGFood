import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../../catalog/widgets/product_card.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  final List categories = const ['Tous', 'Burger', 'Pizza', 'Tacos'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;
    void filtrer(){
      final products = ref.watch(filteredProductsProvider);
          products.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text('Aucun produit disponible dans cette catégorie.'),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ProductCard(product: products[index], isFavorite: false, onFavoriteToggle: () {  },),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                );
    }


    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          filtrer();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).state = category;
              },
              selectedColor: primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}