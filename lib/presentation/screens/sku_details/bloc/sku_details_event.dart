import 'package:equatable/equatable.dart';

abstract class SkuDetailsEvent extends Equatable {
  const SkuDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSkuDetails extends SkuDetailsEvent {
  final String skuUid;

  const LoadSkuDetails(this.skuUid);

  @override
  List<Object?> get props => [skuUid];
}
