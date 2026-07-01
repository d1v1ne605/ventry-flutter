part of 'edit_sku_images_bloc.dart';

class EditSkuImagesState {
  final BaseStatus status;
  final String? errorMessage;
  final SkuEntity? updatedSku;

  const EditSkuImagesState({
    this.status = BaseStatus.initial,
    this.errorMessage,
    this.updatedSku,
  });

  bool get isSaving => status == BaseStatus.loading;

  EditSkuImagesState copyWith({
    BaseStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    SkuEntity? updatedSku,
    bool clearUpdatedSku = false,
  }) {
    return EditSkuImagesState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      updatedSku: clearUpdatedSku ? null : (updatedSku ?? this.updatedSku),
    );
  }
}
