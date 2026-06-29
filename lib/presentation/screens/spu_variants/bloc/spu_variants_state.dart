import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';

class SpuVariantsState extends Equatable {
  final BaseStatus status;
  final SkuSpuGroupEntity? group;
  final String? errorMessage;

  const SpuVariantsState({
    this.status = BaseStatus.initial,
    this.group,
    this.errorMessage,
  });

  SpuVariantsState copyWith({
    BaseStatus? status,
    SkuSpuGroupEntity? group,
    String? errorMessage,
  }) {
    return SpuVariantsState(
      status: status ?? this.status,
      group: group ?? this.group,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, group, errorMessage];
}
