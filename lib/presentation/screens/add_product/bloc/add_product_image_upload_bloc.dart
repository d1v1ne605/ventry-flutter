import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:ventry_flutter/domain/entities/product/upload_product_image_params.dart';
import 'package:ventry_flutter/domain/usecases/product/upload_product_images_usecase.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_image_upload_state.dart';

@injectable
class AddProductImageUploadBloc
    extends Bloc<AddProductImageUploadEvent, AddProductImageUploadState> {
  final UploadProductImagesUseCase _uploadProductImagesUseCase;

  AddProductImageUploadBloc(this._uploadProductImagesUseCase)
    : super(const AddProductImageUploadState()) {
    on<UploadAddProductImagesEvent>(_onUploadImages);
    on<RemoveAddProductImageEvent>(_onRemoveImage);
  }

  Future<void> _onUploadImages(
    UploadAddProductImagesEvent event,
    Emitter<AddProductImageUploadState> emit,
  ) async {
    if (event.files.isEmpty) {
      return;
    }

    emit(state.copyWith(isUploading: true, clearErrorMessage: true));

    final params = event.files
        .where((file) => !_containsLocalPath(file.path))
        .map(
          (file) => UploadProductImageParams(
            filePath: file.path,
            mimeType: _resolveMimeType(file.path),
          ),
        )
        .toList();

    if (params.isEmpty) {
      emit(state.copyWith(isUploading: false, clearErrorMessage: true));
      return;
    }

    final result = await _uploadProductImagesUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(isUploading: false, errorMessage: failure.message),
      ),
      (uploadedImages) {
        final newImages = uploadedImages
            .map(
              (image) => AddProductImageItem(
                localPath: image.localPath,
                objectKey: image.objectKey,
              ),
            )
            .toList();

        emit(
          state.copyWith(
            images: [...state.images, ...newImages],
            isUploading: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void _onRemoveImage(
    RemoveAddProductImageEvent event,
    Emitter<AddProductImageUploadState> emit,
  ) {
    if (event.index < 0 || event.index >= state.images.length) {
      return;
    }

    final updatedImages = List<AddProductImageItem>.from(state.images)
      ..removeAt(event.index);
    emit(state.copyWith(images: updatedImages, clearErrorMessage: true));
  }

  bool _containsLocalPath(String localPath) {
    return state.images.any((image) => image.localPath == localPath);
  }

  String _resolveMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();

    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
