class CreateUnitRequest {
  const CreateUnitRequest({required this.name});

  final String name;

  Map<String, dynamic> toJson() => {'name': name};
}

class ProductUnitConfigurationRequest {
  const ProductUnitConfigurationRequest({
    required this.version,
    this.baseUnitId,
    this.createSkus = const [],
    this.updateSkus = const [],
    this.discontinueSkus = const [],
  });

  final int version;
  final int? baseUnitId;
  final List<Map<String, dynamic>> createSkus;
  final List<Map<String, dynamic>> updateSkus;
  final List<Map<String, dynamic>> discontinueSkus;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      if (baseUnitId != null) 'baseUnitId': baseUnitId,
      if (createSkus.isNotEmpty) 'createSkus': createSkus,
      if (updateSkus.isNotEmpty) 'updateSkus': updateSkus,
      if (discontinueSkus.isNotEmpty) 'discontinueSkus': discontinueSkus,
    };
  }
}
