import 'package:equatable/equatable.dart';

class AddProductImageItem extends Equatable {
  final String localPath;
  final String objectKey;

  const AddProductImageItem({required this.localPath, required this.objectKey});

  @override
  List<Object?> get props => [localPath, objectKey];
}

class AddProductImageUploadState extends Equatable {
  final List<AddProductImageItem> images;
  final bool isUploading;
  final String? errorMessage;

  const AddProductImageUploadState({
    this.images = const [],
    this.isUploading = false,
    this.errorMessage,
  });

  AddProductImageUploadState copyWith({
    List<AddProductImageItem>? images,
    bool? isUploading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddProductImageUploadState(
      images: images ?? this.images,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [images, isUploading, errorMessage];
}
