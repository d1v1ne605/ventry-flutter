import 'package:equatable/equatable.dart';

class UploadProductImageParams extends Equatable {
  final String filePath;
  final String mimeType;

  const UploadProductImageParams({
    required this.filePath,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [filePath, mimeType];
}
