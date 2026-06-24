import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/usecases/product/create_product_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_skus_usecase.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_event.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_state.dart';

EventTransformer<T> _debounceRestartable<T>(Duration duration) {
  return (events, mapper) =>
      events.debounceTime(duration).switchMap(mapper);
}

@injectable
class ProductCatalogBloc
    extends BaseViewModel<ProductCatalogEvent, ProductCatalogState> {
  final GetSkusUseCase _getSkusUseCase;
  final CreateProductUseCase _createProductUseCase;

  ProductCatalogBloc(
    AppLogger logger,
    this._getSkusUseCase,
    this._createProductUseCase,
  ) : super(const ProductCatalogState(), logger) {
    // droppable: ignore new events while one is already being processed
    on<LoadSkus>(_onLoadSkus, transformer: droppable());
    // restartable + debounce: cancel previous search, start new one after delay
    on<SearchSkus>(
      _onSearchSkus,
      transformer: _debounceRestartable(const Duration(milliseconds: 500)),
    );
    // droppable: ignore spam clicks on filter chips
    on<FilterSkus>(_onFilterSkus, transformer: droppable());
    on<CreateProduct>(_onCreateProduct);
  }

  Future<void> _onLoadSkus(
    LoadSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getSkusUseCase(
      SkuQueryParams(
        search: state.searchKeyword.isEmpty ? null : state.searchKeyword,
        status: state.filterStatus,
        isStockAlert: state.isStockAlert,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: failure,
          actionStatus: ProductCatalogActionStatus.failure,
        ),
      ),
      (skuList) => emit(
        state.copyWith(
          isLoading: false,
          skus: skuList.items,
          total: skuList.total,
          page: skuList.page,
          totalPages: skuList.totalPages,
        ),
      ),
    );
  }

  Future<void> _onSearchSkus(
    SearchSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, searchKeyword: event.query));

    final result = await _getSkusUseCase(
      SkuQueryParams(
        search: event.query.isEmpty ? null : event.query,
        status: state.filterStatus,
        isStockAlert: state.isStockAlert,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: failure,
          actionStatus: ProductCatalogActionStatus.failure,
        ),
      ),
      (skuList) => emit(
        state.copyWith(
          isLoading: false,
          skus: skuList.items,
          total: skuList.total,
          page: skuList.page,
          totalPages: skuList.totalPages,
        ),
      ),
    );
  }

  Future<void> _onFilterSkus(
    FilterSkus event,
    Emitter<ProductCatalogState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      filterStatus: event.status,
      isStockAlert: event.isStockAlert,
      clearFilterStatus: event.status == null,
      clearStockAlert: event.isStockAlert == null,
    ));

    final result = await _getSkusUseCase(
      SkuQueryParams(
        search: state.searchKeyword.isEmpty ? null : state.searchKeyword,
        status: event.status,
        isStockAlert: event.isStockAlert,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: failure,
          actionStatus: ProductCatalogActionStatus.failure,
        ),
      ),
      (skuList) => emit(
        state.copyWith(
          isLoading: false,
          skus: skuList.items,
          total: skuList.total,
          page: skuList.page,
          totalPages: skuList.totalPages,
        ),
      ),
    );
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductCatalogState> emit,
  ) async {
    emit(state.copyWith(
      isSubmitting: true,
      actionStatus: ProductCatalogActionStatus.initial,
    ));

    final result = await _createProductUseCase(event.params);

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
        emit(state.copyWith(
          isSubmitting: false,
          actionStatus: ProductCatalogActionStatus.success,
        ));
        // Automatically refresh list after create
        add(const LoadSkus());
      },
    );
  }
}
