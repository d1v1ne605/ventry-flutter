import 'package:equatable/equatable.dart';

class UpdateSkuImagesParams extends Equatable {
  final String skuUid;
  final int version;
  final List<String> imageKeys;

  const UpdateSkuImagesParams({
    required this.skuUid,
    required this.version,
    this.imageKeys = const [],
  });

  @override
  List<Object?> get props => [skuUid, version, imageKeys];
}
