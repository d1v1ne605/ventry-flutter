/// Model representing a product attribute key-value pair.
class ProductAttribute {
  final String id;
  String key;
  String value;

  ProductAttribute({
    required this.id,
    this.key = '',
    this.value = '',
  });
}
