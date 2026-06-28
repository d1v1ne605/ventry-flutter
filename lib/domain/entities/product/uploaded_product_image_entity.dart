import 'package:equatable/equatable.dart';

class UploadedProductImageEntity extends Equatable {
  final String localPath;
  final String objectKey;

  const UploadedProductImageEntity({
    required this.localPath,
    required this.objectKey,
  });

  @override
  List<Object?> get props => [localPath, objectKey];
}
