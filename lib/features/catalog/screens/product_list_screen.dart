import 'package:flutter/material.dart';
import 'package:steph_g_food/features/catalog/models/product.dart';
import '../services/favorites_service.dart';
import '../services/product_repository.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Chargement asynchrone des données dynamiques (Favoris + Produits JSON)
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final favorites = await FavoritesService.getFavorites();
    final products = await ProductRepository.getProducts();

    setState(() {
      _favoriteIds = favorites.toSet();
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(String productId) async {
    final isFav = await FavoritesService.toggleFavorite(productId);
    setState(() {
      if (isFav) {
        _favoriteIds.add(productId);
      } else {
        _favoriteIds.remove(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(child: Text("Aucun produit disponible"));
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  padding: const EdgeInsets.all(12),
  itemCount: _products.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,       
    crossAxisSpacing: 12,    
    mainAxisSpacing: 12,     
    childAspectRatio: 0.7, 
  ),
  itemBuilder: (context, index) {
    return ProductCard(
      product: _products[index],
      isFavorite: _favoriteIds.contains(_products[index].id),
      onFavoriteToggle: () => _toggleFavorite(_products[index].id),
    );
  },
);
        },
      ),
    );
  }
}