import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';

enum ProductCatalogActionStatus { initial, success, failure }

enum ProductCatalogDisplayMode { grouped, flat }

class ProductCatalogState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSubmitting;
  final List<SkuSpuGroupEntity> spuGroups;
  final String searchKeyword;
  final String? filterStatus;
  final bool? isStockAlert;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasReachedEnd;
  final Failure? failure;
  final ProductCatalogActionStatus actionStatus;
  final ProductCatalogDisplayMode displayMode;

  const ProductCatalogState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.spuGroups = const [],
    this.searchKeyword = '',
    this.filterStatus,
    this.isStockAlert,
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.totalPages = 0,
    this.hasReachedEnd = false,
    this.failure,
    this.actionStatus = ProductCatalogActionStatus.initial,
    this.displayMode = ProductCatalogDisplayMode.grouped,
  });

  bool get hasNextPage => !hasReachedEnd;

  List<SkuEntity> get flattenedSkus =>
      spuGroups.expand((group) => group.sortedSkus).toList(growable: false);

  ProductCatalogState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSubmitting,
    List<SkuSpuGroupEntity>? spuGroups,
    String? searchKeyword,
    String? filterStatus,
    bool? isStockAlert,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasReachedEnd,
    Failure? failure,
    ProductCatalogActionStatus? actionStatus,
    ProductCatalogDisplayMode? displayMode,
    bool clearFilterStatus = false,
    bool clearStockAlert = false,
  }) {
    return ProductCatalogState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      spuGroups: spuGroups ?? this.spuGroups,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      filterStatus: clearFilterStatus
          ? null
          : (filterStatus ?? this.filterStatus),
      isStockAlert: clearStockAlert
          ? null
          : (isStockAlert ?? this.isStockAlert),
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      failure: failure ?? this.failure,
      actionStatus: actionStatus ?? this.actionStatus,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    isSubmitting,
    spuGroups,
    searchKeyword,
    filterStatus,
    isStockAlert,
    total,
    page,
    limit,
    totalPages,
    hasReachedEnd,
    failure,
    actionStatus,
    displayMode,
  ];
}
