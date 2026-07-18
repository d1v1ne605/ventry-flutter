import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/usecases/product/get_skus_usecase.dart';
import 'package:ventry_flutter/presentation/screens/spu_variants/bloc/spu_variants_event.dart';
import 'package:ventry_flutter/presentation/screens/spu_variants/bloc/spu_variants_state.dart';

@injectable
class SpuVariantsBloc
    extends BaseViewModel<SpuVariantsEvent, SpuVariantsState> {
  final GetSkusUseCase _getSkusUseCase;

  SpuVariantsBloc(AppLogger logger, this._getSkusUseCase)
    : super(const SpuVariantsState(), logger) {
    on<LoadSpuVariants>(_onLoadSpuVariants);
  }

  Future<void> _onLoadSpuVariants(
    LoadSpuVariants event,
    Emitter<SpuVariantsState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading, errorMessage: null));

    final result = await _getSkusUseCase(
      SkuQueryParams(spuUid: event.spuUid, page: 1, limit: 1),
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
      (response) {
        final group = response.items.isEmpty ? null : response.items.first;
        if (group == null) {
          emit(
            state.copyWith(
              status: BaseStatus.failure,
              errorMessage: AppStrings.noVariantsFound,
            ),
          );
          return;
        }

        emit(state.copyWith(status: BaseStatus.success, group: group));
      },
    );
  }
}
