import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/cart/providers/cart_provider.dart';
import 'package:steph_g_food/features/cart/screens/cart_screen.dart';

class CartFloatingActionButton extends ConsumerWidget {
  const CartFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute en temps réel le nombre d'articles
    final totalItems = ref.watch(cartTotalItemsProvider);

    return FloatingActionButton(
      onPressed: () {
        // Redirige vers la page du panier/commande au clic
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const CartScreen()));
      },
      child: Badge(
        // Le badge apparaît dès qu'au moins 1 article est sélectionné
        isLabelVisible: totalItems > 0,
        label: Text(
          '$totalItems',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        child: const Icon(Icons.shopping_cart, size: 32),
      ),
    );
  }
}
