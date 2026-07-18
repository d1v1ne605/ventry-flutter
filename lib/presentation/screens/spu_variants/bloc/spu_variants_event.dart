import 'package:equatable/equatable.dart';

abstract class SpuVariantsEvent extends Equatable {
  const SpuVariantsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSpuVariants extends SpuVariantsEvent {
  final String spuUid;

  const LoadSpuVariants(this.spuUid);

  @override
  List<Object?> get props => [spuUid];
}
