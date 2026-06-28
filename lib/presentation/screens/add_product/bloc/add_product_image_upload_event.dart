import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddProductImageUploadEvent extends Equatable {
  const AddProductImageUploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadAddProductImagesEvent extends AddProductImageUploadEvent {
  final List<XFile> files;

  const UploadAddProductImagesEvent(this.files);

  @override
  List<Object?> get props => [files];
}

class RemoveAddProductImageEvent extends AddProductImageUploadEvent {
  final int index;

  const RemoveAddProductImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}
