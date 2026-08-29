import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/commande.dart';

class CommandeNotifier extends StateNotifier<List<Commande>> {
  CommandeNotifier() : super([]);

  // Création d'une nouvelle commande

  void passezCommande(List<dynamic> cartItems, double total) {
    if (cartItems.isEmpty) return;

    // Convertir chaque CartItem du panier en CommandeItem (ou adapter la structure)
    final commandeItems = cartItems.map((cartItem) {
      return CommandeItem(
        product: cartItem.product,
        quantity: cartItem.quantity,
      );
    }).toList();

    final newCommande = Commande(
      id: 'CMD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: commandeItems,
      totalAmount: total,
      date: DateTime.now(),
      status: CommandeStatus.enPreparation,
      deliveryAddress: 'Antananarivo, 101', // Addresse par défaut
    );

    state = [newCommande, ...state];
  }
}

final commandeProvider =
    StateNotifierProvider<CommandeNotifier, List<Commande>>((ref) {
      return CommandeNotifier();
    });

// Commandes "En cours"
final activeCommandeProvider = Provider<List<Commande>>((ref) {
  final commandes = ref.watch(commandeProvider);
  return commandes
      .where(
        (c) =>
            c.status == CommandeStatus.enPreparation ||
            c.status == CommandeStatus.enLivraison,
      )
      .toList();
});

// Commandes "Historique"
final pastCommandeProvider = Provider<List<Commande>>((ref) {
  final commandes = ref.watch(commandeProvider);
  return commandes
      .where(
        (c) =>
            c.status == CommandeStatus.livree ||
            c.status == CommandeStatus.annulee,
      )
      .toList();
});
