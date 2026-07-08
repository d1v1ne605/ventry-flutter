import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/delete_sku_params.dart';
import 'package:ventry_flutter/domain/usecases/product/delete_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_sku_by_uid_usecase.dart';
import 'sku_details_event.dart';
import 'sku_details_state.dart';

@injectable
class SkuDetailsBloc extends BaseViewModel<SkuDetailsEvent, SkuDetailsState> {
  final GetSkuByUidUseCase _getSkuByUidUseCase;
  final DeleteSkuUseCase _deleteSkuUseCase;

  SkuDetailsBloc(
    AppLogger logger,
    this._getSkuByUidUseCase,
    this._deleteSkuUseCase,
  ) : super(const SkuDetailsState(), logger) {
    on<LoadSkuDetails>(_onLoadSkuDetails);
    on<DeleteSkuDetails>(_onDeleteSkuDetails);
  }

  Future<void> _onLoadSkuDetails(
    LoadSkuDetails event,
    Emitter<SkuDetailsState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, clearErrorMessage: true));

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
        emit(state.copyWith(status: BaseStatus.success, sku: sku));
      },
    );
  }

  Future<void> _onDeleteSkuDetails(
    DeleteSkuDetails event,
    Emitter<SkuDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        deleteStatus: SkuDetailsDeleteStatus.loading,
        clearDeleteMessage: true,
        clearDeletedSkuUid: true,
      ),
    );

    final result = await _deleteSkuUseCase(
      DeleteSkuParams(skuUid: event.skuUid, version: event.version),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            deleteStatus: SkuDetailsDeleteStatus.failure,
            deleteMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (deletedSkuUid) {
        emit(
          state.copyWith(
            deleteStatus: SkuDetailsDeleteStatus.success,
            deletedSkuUid: deletedSkuUid,
          ),
        );
      },
    );
  }
}
