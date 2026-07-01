import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_images_params.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_images_usecase.dart';

part 'edit_sku_images_event.dart';
part 'edit_sku_images_state.dart';

@injectable
class EditSkuImagesBloc
    extends BaseViewModel<EditSkuImagesEvent, EditSkuImagesState> {
  final UpdateSkuImagesUseCase _updateSkuImagesUseCase;

  EditSkuImagesBloc(AppLogger logger, this._updateSkuImagesUseCase)
    : super(const EditSkuImagesState(), logger) {
    on<SaveEditSkuImagesEvent>(_onSaveGallery);
  }

  Future<void> _onSaveGallery(
    SaveEditSkuImagesEvent event,
    Emitter<EditSkuImagesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.loading,
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );

    final result = await _updateSkuImagesUseCase(
      UpdateSkuImagesParams(
        skuUid: event.skuUid,
        version: event.version,
        imageKeys: event.imageKeys,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (updatedSku) {
        emit(
          state.copyWith(status: BaseStatus.success, updatedSku: updatedSku),
        );
      },
    );
  }
}
