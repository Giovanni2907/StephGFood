import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:steph_g_food/features/commande/models/commande.dart';
import '../providers/cart_provider.dart';
import '../../commande/providers/commande_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute de la liste des articles et des totaux
    final cart = ref.watch(cartNotifierProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Votre panier est vide'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                          '${item.product.price} € x ${item.quantity} = ${item.totalPrice.toStringAsFixed(2)} €',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .decrementQuantity(item.product.id);
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .addProduct(item.product);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .removeProduct(item.product.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: ColorScheme.dark(primary: Theme.of(context).colorScheme.primary).primary.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total :',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    // Le bouton est désactivé si le panier est vide
                    onPressed: cart.isEmpty
                        ? null
                        : () async {
                            // 1. Indiquer à l'utilisateur que la commande est en cours
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Validation de la commande en cours...'),
                                  ],
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );

                            // Simulation d'un traitement réseau
                            await Future.delayed(const Duration(seconds: 1));

                            // 2. Enregistrer la commande dans le CommandeNotifier
                           ref.read(commandeProvider.notifier).passezCommande(
      cart.map((cartItem) => CommandeItem(
        product: cartItem.product,
        quantity: cartItem.quantity,
      )).toList(),
      totalPrice,
    );

                            // 3. Vider le panier dans le state Riverpod
                            ref.read(cartNotifierProvider.notifier).clearCart();

                            // 4. Confirmer le succès et rediriger
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: const Text('Commande validée avec succès ! 🎉'),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              );

                              // Redirection vers la page des commandes (GoRouter)
                              context.pushNamed('commande');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Valider la commande',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}