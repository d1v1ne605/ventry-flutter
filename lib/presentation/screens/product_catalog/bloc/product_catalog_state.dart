import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

enum ProductCatalogActionStatus { initial, success, failure }

class ProductCatalogState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<SkuEntity> skus;
  final String searchKeyword;
  final String? filterStatus;
  final bool? isStockAlert;
  final int total;
  final int page;
  final int totalPages;
  final Failure? failure;
  final ProductCatalogActionStatus actionStatus;

  const ProductCatalogState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.skus = const [],
    this.searchKeyword = '',
    this.filterStatus,
    this.isStockAlert,
    this.total = 0,
    this.page = 1,
    this.totalPages = 1,
    this.failure,
    this.actionStatus = ProductCatalogActionStatus.initial,
  });

  bool get hasNextPage => page < totalPages;

  ProductCatalogState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<SkuEntity>? skus,
    String? searchKeyword,
    String? filterStatus,
    bool? isStockAlert,
    int? total,
    int? page,
    int? totalPages,
    Failure? failure,
    ProductCatalogActionStatus? actionStatus,
    bool clearFilterStatus = false,
    bool clearStockAlert = false,
  }) {
    return ProductCatalogState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      skus: skus ?? this.skus,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      filterStatus: clearFilterStatus ? null : (filterStatus ?? this.filterStatus),
      isStockAlert: clearStockAlert ? null : (isStockAlert ?? this.isStockAlert),
      total: total ?? this.total,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      failure: failure ?? this.failure,
      actionStatus: actionStatus ?? this.actionStatus,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        skus,
        searchKeyword,
        filterStatus,
        isStockAlert,
        total,
        page,
        totalPages,
        failure,
        actionStatus,
      ];
}
