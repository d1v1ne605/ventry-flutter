import 'package:equatable/equatable.dart';

class UpdateSpuParams extends Equatable {
  final String spuUid;
  final int version;
  final String? name;
  final String? categoryUid;
  final String? description;
  final String? currency;
  final String? unitOfMeasure;

  const UpdateSpuParams({
    required this.spuUid,
    required this.version,
    this.name,
    this.categoryUid,
    this.description,
    this.currency,
    this.unitOfMeasure,
  });

  @override
  List<Object?> get props => [
    spuUid,
    version,
    name,
    categoryUid,
    description,
    currency,
    unitOfMeasure,
  ];
}
