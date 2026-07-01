part of 'edit_sku_images_bloc.dart';

abstract class EditSkuImagesEvent {
  const EditSkuImagesEvent();
}

class SaveEditSkuImagesEvent extends EditSkuImagesEvent {
  final String skuUid;
  final int version;
  final List<String> imageKeys;

  const SaveEditSkuImagesEvent({
    required this.skuUid,
    required this.version,
    required this.imageKeys,
  });
}
