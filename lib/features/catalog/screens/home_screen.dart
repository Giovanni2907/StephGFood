import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/catalog/screens/product_list_screen.dart';
import 'package:steph_g_food/features/catalog/widgets/caroussel.dart';
import 'package:steph_g_food/features/search/providers/search_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'NOS MEILLEURS PLATS AU MEILLEUR PRIX',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BIENVENUE SUR StephGFood',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 16),
                        EcommerceCarouselCard(),

                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (value) {
                            ref.read(searchQueryProvider.notifier).state =
                                value;
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Rechercher un plat (ex: Burger, Pizza)...',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),

                            prefixIcon: const Icon(LucideIcons.search),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(LucideIcons.x),
                                    onPressed: () {
                                      ref
                                              .read(
                                                searchQueryProvider.notifier,
                                              )
                                              .state =
                                          '';
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: theme.colorScheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(36),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Catégorie de produits',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const SizedBox(
                          height: 500,
                          width: double.infinity,
                          child: ProductListScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
