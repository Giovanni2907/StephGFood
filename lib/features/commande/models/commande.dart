import '../../catalog/models/product.dart';

enum CommandeStatus {
  enPreparation('En préparation', 0.33),
  enLivraison('En cours de livraison', 0.66),
  livree('Livrée', 1.0),
  annulee('Annulée', 0.0);

  final String label;
  final double progress;
  const CommandeStatus(this.label, this.progress);
}

class CommandeItem {
  final Product product;
  final int quantity;

  const CommandeItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}

class Commande {
  final String id;
  final DateTime date;
  final List items;
  final double totalAmount;
  final CommandeStatus status;
  final String deliveryAddress;


  const Commande({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
  });

  bool get isActive => status == CommandeStatus.enPreparation || status == CommandeStatus.enPreparation;
}