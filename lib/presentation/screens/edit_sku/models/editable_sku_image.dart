import 'package:equatable/equatable.dart';

class EditableSkuImage extends Equatable {
  final String imageKey;
  final String previewPath;
  final bool isLocalFile;

  const EditableSkuImage({
    required this.imageKey,
    required this.previewPath,
    required this.isLocalFile,
  });

  @override
  List<Object?> get props => [imageKey, previewPath, isLocalFile];
}
