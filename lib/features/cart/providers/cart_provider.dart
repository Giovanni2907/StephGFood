import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void clearCart() {
    state = [];
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void decrementQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (state[index].quantity > 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == index)
              state[i].copyWith(quantity: state[i].quantity - 1)
            else
              state[i],
        ];
      } else {
        removeProduct(productId);
      }
    }
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>(
      (ref) => CartNotifier(),
    );
final cartTotalPriceProvider = Provider<double>((ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.fold(0, (sum, item) => sum + item.totalPrice);
});

// 2. Provider pour le nombre total d'articles
final cartTotalItemsProvider = Provider<int>((ref) {
  final cart = ref.watch(cartNotifierProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});
