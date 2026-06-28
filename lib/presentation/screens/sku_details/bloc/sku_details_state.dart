import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class SkuDetailsState extends Equatable {
  final BaseStatus status;
  final SkuEntity? sku;
  final String? errorMessage;

  const SkuDetailsState({
    this.status = BaseStatus.initial,
    this.sku,
    this.errorMessage,
  });

  SkuDetailsState copyWith({
    BaseStatus? status,
    SkuEntity? sku,
    String? errorMessage,
  }) {
    return SkuDetailsState(
      status: status ?? this.status,
      sku: sku ?? this.sku,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sku, errorMessage];
}
