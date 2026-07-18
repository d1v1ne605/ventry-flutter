class CreateSkuRequest {
  const CreateSkuRequest({
    required this.spuUid,
    this.skuCode,
    this.barCode,
    this.sellingPrice,
    this.costPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.imageKeys = const [],
    this.isSellable = true,
    this.attributeValueUids = const [],
  });

  final String spuUid;
  final String? skuCode;
  final String? barCode;
  final double? sellingPrice;
  final double? costPrice;
  final int? stockQuantity;
  final int? minStockQuantity;
  final List<String> imageKeys;
  final bool isSellable;
  final List<String> attributeValueUids;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'spuUid': spuUid,
      'imageKeys': imageKeys,
      'isSellable': isSellable,
      'attributeValueUids': attributeValueUids,
    };

    void writeNotNull(String key, Object? value) {
      if (value != null) {
        json[key] = value;
      }
    }

    writeNotNull('skuCode', skuCode);
    writeNotNull('barCode', barCode);
    writeNotNull('sellingPrice', sellingPrice);
    writeNotNull('costPrice', costPrice);
    writeNotNull('stockQuantity', stockQuantity);
    writeNotNull('minStockQuantity', minStockQuantity);

    return json;
  }
}
