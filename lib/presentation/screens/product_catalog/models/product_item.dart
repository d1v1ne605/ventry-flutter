/// Represents the stock status of a product.
enum StockStatus {
  inStock,
  lowStock,
  outOfStock;

  bool get isOutOfStock => this == StockStatus.outOfStock;
}

/// Lightweight UI model for a single product in the catalog list.
///
/// This is a pure data class — business logic and fetching will be
/// handled by the Bloc layer in a future iteration.
class ProductItem {
  const ProductItem({
    required this.id,
    required this.name,
    required this.meta,
    required this.sku,
    required this.price,
    required this.stockStatus,
    required this.stockCount,
    this.imageUrl,
  });

  final String id;
  final String name;

  /// Combined meta string, e.g. "Size: 128GB • Color: Titanium"
  final String meta;

  final String sku;
  final double price;
  final StockStatus stockStatus;

  /// Quantity in stock. Null means "Out".
  final int? stockCount;

  /// Optional remote image URL. Falls back to placeholder when null.
  final String? imageUrl;
}
