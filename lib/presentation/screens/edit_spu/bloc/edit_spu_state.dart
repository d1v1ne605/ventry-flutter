import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/entities/product/spu_entity.dart';

class EditSpuState extends Equatable {
  final BaseStatus loadStatus;
  final BaseStatus submitStatus;
  final SpuEntity? spu;
  final List<CategoryEntity> categories;
  final String? selectedCategoryUid;
  final String? selectedCategoryName;
  final String name;
  final String currency;
  final String unitOfMeasure;
  final String description;
  final SpuEntity? updatedSpu;
  final String? errorMessage;

  const EditSpuState({
    this.loadStatus = BaseStatus.initial,
    this.submitStatus = BaseStatus.initial,
    this.spu,
    this.categories = const [],
    this.selectedCategoryUid,
    this.selectedCategoryName,
    this.name = '',
    this.currency = '',
    this.unitOfMeasure = '',
    this.description = '',
    this.updatedSpu,
    this.errorMessage,
  });

  CategoryEntity? get selectedCategory {
    for (final category in categories) {
      if (category.uid == selectedCategoryUid) {
        return category;
      }
    }
    return null;
  }

  bool get hasChanges {
    final currentSpu = spu;
    if (currentSpu == null) {
      return false;
    }

    return name.trim() != currentSpu.name.trim() ||
        selectedCategoryUid != currentSpu.categoryUid ||
        _nullableTrim(description) != _nullableTrim(currentSpu.description) ||
        _nullableTrim(currency) != _nullableTrim(currentSpu.currency) ||
        _nullableTrim(unitOfMeasure) != _nullableTrim(currentSpu.unitOfMeasure);
  }

  bool get canSubmit => hasChanges && name.trim().isNotEmpty;

  EditSpuState copyWith({
    BaseStatus? loadStatus,
    BaseStatus? submitStatus,
    SpuEntity? spu,
    List<CategoryEntity>? categories,
    String? selectedCategoryUid,
    bool clearSelectedCategoryUid = false,
    String? selectedCategoryName,
    bool clearSelectedCategoryName = false,
    String? name,
    String? currency,
    String? unitOfMeasure,
    String? description,
    SpuEntity? updatedSpu,
    bool clearUpdatedSpu = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return EditSpuState(
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      spu: spu ?? this.spu,
      categories: categories ?? this.categories,
      selectedCategoryUid: clearSelectedCategoryUid
          ? null
          : selectedCategoryUid ?? this.selectedCategoryUid,
      selectedCategoryName: clearSelectedCategoryName
          ? null
          : selectedCategoryName ?? this.selectedCategoryName,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      description: description ?? this.description,
      updatedSpu: clearUpdatedSpu ? null : updatedSpu ?? this.updatedSpu,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    submitStatus,
    spu,
    categories,
    selectedCategoryUid,
    selectedCategoryName,
    name,
    currency,
    unitOfMeasure,
    description,
    updatedSpu,
    errorMessage,
  ];
}

String? _nullableTrim(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}
