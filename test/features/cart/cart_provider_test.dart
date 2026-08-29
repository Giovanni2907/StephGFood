import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/cart/providers/cart_provider.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';

void main() {
  late ProviderContainer container;

  const testProduct1 = Product(
    id: 'p1',
    name: 'Burger Cheeseburger',
    price: 8.50,
    image: 'assets/images/burger.png', description: '', category: '', 
  );

  const testProduct2 = Product(
    id: 'p2',
    name: 'Frites Maison',
    price: 3.50,
    image: 'assets/images/pizza.png', description: '', category: '',
  );

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('CartNotifier Tests', () {
    test('Le panier doit être vide à l initialisation', () {
      final cart = container.read(cartNotifierProvider);
      expect(cart, isEmpty);
    });

    test('Ajouter un produit doit l insérer dans le panier', () {
      final notifier = container.read(cartNotifierProvider.notifier);
      notifier.addProduct(testProduct1);

      final cart = container.read(cartNotifierProvider);
      expect(cart.length, equals(1));
      expect(cart.first.product.id, equals('p1'));
      expect(cart.first.quantity, equals(1));
    });

    test('Ajouter deux fois le même produit doit incrémenter la quantité', () {
      final notifier = container.read(cartNotifierProvider.notifier);
      notifier.addProduct(testProduct1);
      notifier.addProduct(testProduct1);

      final cart = container.read(cartNotifierProvider);
      expect(cart.length, equals(1));
      expect(cart.first.quantity, equals(2));
    });

    test('Diminuer la quantité doit décrémenter ou retirer le produit à 0', () {
      final notifier = container.read(cartNotifierProvider.notifier);
      notifier.addProduct(testProduct1);
      notifier.addProduct(testProduct1);

      // Décrémente de 2 à 1
      notifier.decrementQuantity(testProduct1.id);
      expect(container.read(cartNotifierProvider).first.quantity, equals(1));

      // Décrémente de 1 à 0 -> Retrait du panier
      notifier.decrementQuantity(testProduct1.id);
      expect(container.read(cartNotifierProvider), isEmpty);
    });

    test('Calcul correct du prix total avec cartTotalPriceProvider', () {
      final notifier = container.read(cartNotifierProvider.notifier);
      notifier.addProduct(testProduct1); // 8.50 €
      notifier.addProduct(testProduct1); // 8.50 €
      notifier.addProduct(testProduct2); // 3.50 €

      final total = container.read(cartTotalPriceProvider);
      expect(total, equals(20.50));
    });

    test('Vider le panier doit supprimer tous les articles', () {
      final notifier = container.read(cartNotifierProvider.notifier);
      notifier.addProduct(testProduct1);
      notifier.addProduct(testProduct2);

      notifier.clearCart();

      expect(container.read(cartNotifierProvider), isEmpty);
      expect(container.read(cartTotalPriceProvider), equals(0.0));
    });
  });
}