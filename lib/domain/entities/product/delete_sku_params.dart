import 'package:equatable/equatable.dart';

class DeleteSkuParams extends Equatable {
  final String skuUid;
  final int version;

  const DeleteSkuParams({required this.skuUid, required this.version});

  @override
  List<Object?> get props => [skuUid, version];
}
