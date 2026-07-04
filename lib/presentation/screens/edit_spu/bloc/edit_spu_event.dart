import 'package:equatable/equatable.dart';

abstract class EditSpuEvent extends Equatable {
  const EditSpuEvent();

  @override
  List<Object?> get props => [];
}

class LoadEditSpu extends EditSpuEvent {
  final String spuUid;

  const LoadEditSpu({required this.spuUid});

  @override
  List<Object?> get props => [spuUid];
}

class EditSpuCategoryChanged extends EditSpuEvent {
  final String? categoryUid;

  const EditSpuCategoryChanged(this.categoryUid);

  @override
  List<Object?> get props => [categoryUid];
}

class EditSpuFormChanged extends EditSpuEvent {
  final String name;
  final String currency;
  final String unitOfMeasure;
  final String description;

  const EditSpuFormChanged({
    required this.name,
    required this.currency,
    required this.unitOfMeasure,
    required this.description,
  });

  @override
  List<Object?> get props => [name, currency, unitOfMeasure, description];
}

class SubmitEditSpu extends EditSpuEvent {
  final String name;
  final String currency;
  final String unitOfMeasure;
  final String description;

  const SubmitEditSpu({
    required this.name,
    required this.currency,
    required this.unitOfMeasure,
    required this.description,
  });

  @override
  List<Object?> get props => [name, currency, unitOfMeasure, description];
}
