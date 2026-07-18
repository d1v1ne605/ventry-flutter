import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

enum SkuDetailsDeleteStatus { initial, loading, success, failure }

class SkuDetailsState extends Equatable {
  final BaseStatus status;
  final SkuEntity? sku;
  final String? errorMessage;
  final SkuDetailsDeleteStatus deleteStatus;
  final String? deleteMessage;
  final String? deletedSkuUid;

  const SkuDetailsState({
    this.status = BaseStatus.initial,
    this.sku,
    this.errorMessage,
    this.deleteStatus = SkuDetailsDeleteStatus.initial,
    this.deleteMessage,
    this.deletedSkuUid,
  });

  SkuDetailsState copyWith({
    BaseStatus? status,
    SkuEntity? sku,
    String? errorMessage,
    SkuDetailsDeleteStatus? deleteStatus,
    String? deleteMessage,
    String? deletedSkuUid,
    bool clearErrorMessage = false,
    bool clearDeleteMessage = false,
    bool clearDeletedSkuUid = false,
  }) {
    return SkuDetailsState(
      status: status ?? this.status,
      sku: sku ?? this.sku,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deleteMessage: clearDeleteMessage
          ? null
          : deleteMessage ?? this.deleteMessage,
      deletedSkuUid: clearDeletedSkuUid
          ? null
          : deletedSkuUid ?? this.deletedSkuUid,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sku,
    errorMessage,
    deleteStatus,
    deleteMessage,
    deletedSkuUid,
  ];
}
