/// Available product categories for the Quick Add dropdown.
class ProductCategory {
  final String id;
  final String name;

  const ProductCategory({required this.id, required this.name});

  static const List<ProductCategory> defaults = [
    ProductCategory(id: 'electronics', name: 'Electronics'),
    ProductCategory(id: 'clothing', name: 'Clothing & Apparel'),
    ProductCategory(id: 'food', name: 'Food & Beverages'),
    ProductCategory(id: 'furniture', name: 'Furniture'),
    ProductCategory(id: 'books', name: 'Books & Stationery'),
    ProductCategory(id: 'tools', name: 'Tools & Hardware'),
    ProductCategory(id: 'cosmetics', name: 'Cosmetics & Beauty'),
    ProductCategory(id: 'sports', name: 'Sports & Outdoors'),
    ProductCategory(id: 'other', name: 'Other'),
  ];
}

/// Add-mode tab selection.
enum AddProductMode { simple, professional }
