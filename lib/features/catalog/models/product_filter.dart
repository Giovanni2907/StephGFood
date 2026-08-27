enum ProductSortOption {
  nameAsc,
  priceAsc,
  priceDesc,
}

class ProductFilter {
  final String searchQuery;
  final String? selectedCategory;
  final double maxPrice;
  final ProductSortOption sortOption;

  const ProductFilter({
    this.searchQuery = '',
    this.selectedCategory,
    this.maxPrice = 100.0,
    this.sortOption = ProductSortOption.nameAsc,
  });

  ProductFilter copyWith({
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
    double? maxPrice,
    ProductSortOption? sortOption,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      maxPrice: maxPrice ?? this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}