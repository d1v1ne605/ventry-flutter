import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

/// Paginated list of [SkuEntity] returned by [GetSkusUseCase].
class SkuListEntity extends Equatable {
  final List<SkuEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const SkuListEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;

  @override
  List<Object?> get props => [items, total, page, limit, totalPages];
}
