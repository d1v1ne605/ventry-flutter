import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/usecases/product/get_sku_by_uid_usecase.dart';
import 'sku_details_event.dart';
import 'sku_details_state.dart';

@injectable
class SkuDetailsBloc extends BaseViewModel<SkuDetailsEvent, SkuDetailsState> {
  final GetSkuByUidUseCase _getSkuByUidUseCase;

  SkuDetailsBloc(
    AppLogger logger,
    this._getSkuByUidUseCase,
  ) : super(const SkuDetailsState(), logger) {
    on<LoadSkuDetails>(_onLoadSkuDetails);
  }

  Future<void> _onLoadSkuDetails(
    LoadSkuDetails event,
    Emitter<SkuDetailsState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, errorMessage: null));

    final result = await _getSkuByUidUseCase(event.skuUid);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (sku) {
        emit(
          state.copyWith(
            status: BaseStatus.success,
            sku: sku,
          ),
        );
      },
    );
  }
}
