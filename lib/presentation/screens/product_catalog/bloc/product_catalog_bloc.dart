import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/usecases/product/create_product_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_latest_generated_sku_code_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_skus_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_event.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_state.dart';

EventTransformer<T> _debounceRestartable<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

@injectable
class ProductCatalogBloc
    extends BaseViewModel<ProductCatalogEvent, ProductCatalogState> {
  static const int _firstPage = 1;

  final GetSkusUseCase _getSkusUseCase;
  final CreateProductUseCase _createProductUseCase;
  final GetLatestGeneratedSkuCodeUseCase _getLatestGeneratedSkuCodeUseCase;

  ProductCatalogBloc(
    AppLogger logger,
    this._getSkusUseCase,
    this._createProductUseCase,
    this._getLatestGeneratedSkuCodeUseCase,
  ) : super(const ProductCatalogState(), logger) {
    // droppable: ignore new events while one is already being processed
    on<LoadSkus>(_onLoadSkus, transformer: droppable());
    on<LoadMoreSkus>(_onLoadMoreSkus, transformer: droppable());
    // restartable + debounce: cancel previous search, start new one after delay
    on<SearchSkus>(
      _onSearchSkus,
      transformer: _debounceRestartable(const Duration(milliseconds: 500)),
    );
    // droppable: ignore spam clicks on filter chips
    on<FilterSkus>(_onFilterSkus, transformer: droppable());
    on<ChangeProductCatalogDisplayMode>(_onChangeDisplayMode);
    on<CreateProduct>(_onCreateProduct);
  }

  Future<void> _onLoadSkus(
    LoadSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    await _loadFirstPage(
      emit,
      searchKeyword: state.searchKeyword,
      filterStatus: state.filterStatus,
      isStockAlert: state.isStockAlert,
    );
  }

  Future<void> _onLoadMoreSkus(
    LoadMoreSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    if (state.isLoading || state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.page + 1;
    final result = await _getSkusUseCase(_buildQueryParams(page: nextPage));

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          failure: failure,
          actionStatus: ProductCatalogActionStatus.failure,
        ),
      ),
      (skuList) => emit(
        state.copyWith(
          isLoadingMore: false,
          spuGroups: [...state.spuGroups, ...skuList.items],
          total: skuList.total,
          page: skuList.page,
          limit: skuList.limit,
          totalPages: skuList.totalPages,
          hasReachedEnd: _hasReachedEnd(
            loadedItemCount: state.spuGroups.length + skuList.items.length,
            total: skuList.total,
            page: skuList.page,
            limit: skuList.limit,
            receivedItemCount: skuList.items.length,
          ),
        ),
      ),
    );
  }

  Future<void> _onSearchSkus(
    SearchSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    await _loadFirstPage(
      emit,
      searchKeyword: event.query,
      filterStatus: state.filterStatus,
      isStockAlert: state.isStockAlert,
    );
  }

  Future<void> _onFilterSkus(
    FilterSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    final filterStatus = event.status;
    final isStockAlert = event.isStockAlert;

    await _loadFirstPage(
      emit,
      searchKeyword: state.searchKeyword,
      filterStatus: filterStatus,
      isStockAlert: isStockAlert,
      clearFilterStatus: filterStatus == null,
      clearStockAlert: isStockAlert == null,
    );
  }

  void _onChangeDisplayMode(
    ChangeProductCatalogDisplayMode event,
    Emitter<ProductCatalogState> emit,
  ) {
    emit(state.copyWith(displayMode: event.displayMode));
  }

  Future<void> _loadFirstPage(
    Emitter<ProductCatalogState> emit, {
    required String searchKeyword,
    required String? filterStatus,
    required bool? isStockAlert,
    bool clearFilterStatus = false,
    bool clearStockAlert = false,
  }) async {
    final currentLimit = state.limit;

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        searchKeyword: searchKeyword,
        filterStatus: filterStatus,
        isStockAlert: isStockAlert,
        page: _firstPage,
        totalPages: 0,
        limit: currentLimit,
        hasReachedEnd: false,
        clearFilterStatus: clearFilterStatus,
        clearStockAlert: clearStockAlert,
      ),
    );

    final result = await _getSkusUseCase(
      SkuQueryParams(
        search: searchKeyword.isEmpty ? null : searchKeyword,
        status: filterStatus,
        isStockAlert: isStockAlert,
        page: _firstPage,
        limit: currentLimit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          failure: failure,
          actionStatus: ProductCatalogActionStatus.failure,
        ),
      ),
      (skuList) => emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          spuGroups: skuList.items,
          total: skuList.total,
          page: skuList.page,
          limit: skuList.limit,
          totalPages: skuList.totalPages,
          hasReachedEnd: _hasReachedEnd(
            loadedItemCount: skuList.items.length,
            total: skuList.total,
            page: skuList.page,
            limit: skuList.limit,
            receivedItemCount: skuList.items.length,
          ),
        ),
      ),
    );
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductCatalogState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        actionStatus: ProductCatalogActionStatus.initial,
      ),
    );

    // Fetch latest generated SKU code
    final latestCodeResult = await _getLatestGeneratedSkuCodeUseCase(
      NoParams(),
    );
    int currentSkuNum = 0;
    latestCodeResult.fold((l) {}, (code) {
      if (code != null && code.startsWith('SP')) {
        final numStr = code.substring(2);
        currentSkuNum = int.tryParse(numStr) ?? 0;
      }
    });

    // Auto-generate SKU codes
    final updatedSkus = event.params.skus.map((sku) {
      if (sku.skuCode == null || sku.skuCode!.trim().isEmpty) {
        currentSkuNum++;
        final newCode = 'SP${currentSkuNum.toString().padLeft(6, '0')}';
        return CreateSkuParams(
          skuCode: newCode,
          barCode: sku.barCode,
          sellingPrice: sku.sellingPrice,
          costPrice: sku.costPrice,
          stockQuantity: sku.stockQuantity,
          minStockQuantity: sku.minStockQuantity,
          imageKeys: sku.imageKeys,
          isSellable: sku.isSellable,
          attributeValueUids: sku.attributeValueUids,
        );
      }
      return sku;
    }).toList();

    final finalParams = CreateProductParams(
      name: event.params.name,
      categoryUid: event.params.categoryUid,
      description: event.params.description,
      brand: event.params.brand,
      imageKeys: event.params.imageKeys,
      currency: event.params.currency,
      unitOfMeasure: event.params.unitOfMeasure,
      globalAttributeValueUids: event.params.globalAttributeValueUids,
      skus: updatedSkus,
    );

    final result = await _createProductUseCase(finalParams);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSubmitting: false,
          failure: failure,
          actionStatus: ProductCatalogActionStatus.failure,
        ),
      ),
      (_) {
        // Single Responsibility: just signal success, let UI dispatch LoadSkus
        emit(
          state.copyWith(
            isSubmitting: false,
            actionStatus: ProductCatalogActionStatus.success,
          ),
        );
        // Automatically refresh list after create
        add(const LoadSkus());
      },
    );
  }

  SkuQueryParams _buildQueryParams({required int page}) {
    return SkuQueryParams(
      search: state.searchKeyword.isEmpty ? null : state.searchKeyword,
      status: state.filterStatus,
      isStockAlert: state.isStockAlert,
      page: page,
      limit: state.limit,
    );
  }

  bool _hasReachedEnd({
    required int loadedItemCount,
    required int total,
    required int page,
    required int limit,
    required int receivedItemCount,
  }) {
    if (receivedItemCount == 0) {
      return true;
    }

    if (total > 0) {
      return loadedItemCount >= total;
    }

    return receivedItemCount < limit;
  }
}
