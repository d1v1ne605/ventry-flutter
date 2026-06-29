import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';

class SkuSpuGroupListEntity extends Equatable {
  final List<SkuSpuGroupEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const SkuSpuGroupListEntity({
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
