import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';
import 'package:steph_g_food/features/cart/providers/cart_provider.dart';
import 'package:steph_g_food/features/catalog/providers/favorites_notifier.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = ref.watch(favoritesNotifierProvider);
    final isFavorite = favoriteIds.contains(widget.product.id);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? LucideIcons.heart : LucideIcons.heart,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              ref
                  .read(favoritesNotifierProvider.notifier)
                  .toggleFavorite(widget.product.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du produit avec héros d'animation
                  Hero(
                    tag: 'product-image-${widget.product.id}',
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.surfaceVariant,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(LucideIcons.utensils, size: 64),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Catégorie et Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(widget.product.category),
                        backgroundColor: theme.colorScheme.primaryContainer,
                      ),
                      Text(
                        '${widget.product.price.toStringAsFixed(2)} €',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nom du produit
                  Text(
                    widget.product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.8,
                      ),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selecteur de quantité
                  Row(
                    children: [
                      Text('Quantité :', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: _decrementQuantity,
                        icon: const Icon(LucideIcons.minus),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$_quantity',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: _incrementQuantity,
                        icon: const Icon(LucideIcons.plus),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Barre d'action inférieure
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(LucideIcons.shoppingBag),
                label: Text(
                  'Ajouter au panier (${(widget.product.price * _quantity).toStringAsFixed(2)} €)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // Ajout au panier via le provider Riverpod
                  ref
                      .read(cartNotifierProvider.notifier)
                      .addProduct(widget.product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.product.name} (x$_quantity) ajouté au panier !',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
