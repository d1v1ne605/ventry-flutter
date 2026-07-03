import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/domain/entities/product/create_sku_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_params.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_image.dart';

enum SkuFormMode {
  edit,
  create;

  bool get isCreate => this == SkuFormMode.create;
}

class SkuFormData extends Equatable {
  const SkuFormData({
    required this.skuName,
    required this.categoryName,
    this.categoryUid,
    required this.barcode,
    required this.skuCode,
    required this.costPrice,
    required this.sellingPrice,
    required this.currency,
    required this.unitOfMeasure,
    required this.isSellable,
    required this.description,
  });

  factory SkuFormData.fromSku(SkuEntity sku) {
    return SkuFormData(
      skuName: sku.spuName,
      categoryName: sku.spuCategoryName ?? '',
      barcode: sku.barCode ?? '',
      skuCode: sku.skuCode ?? '',
      costPrice: _formatPrice(sku.costPrice),
      sellingPrice: _formatPrice(sku.sellingPrice),
      currency: sku.spuCurrency ?? '',
      unitOfMeasure: sku.spuUnitOfMeasure ?? '',
      isSellable: sku.isSellable,
      description: sku.spuDescription ?? '',
    );
  }

  factory SkuFormData.createFromSku(SkuEntity sku) {
    return SkuFormData(
      skuName: sku.spuName,
      categoryName: sku.spuCategoryName ?? '',
      barcode: '',
      skuCode: '',
      costPrice: '',
      sellingPrice: '',
      currency: sku.spuCurrency ?? '',
      unitOfMeasure: sku.spuUnitOfMeasure ?? '',
      isSellable: true,
      description: sku.spuDescription ?? '',
    );
  }

  final String skuName;
  final String categoryName;
  final String? categoryUid;
  final String barcode;
  final String skuCode;
  final String costPrice;
  final String sellingPrice;
  final String currency;
  final String unitOfMeasure;
  final bool isSellable;
  final String description;

  SkuFormData copyWith({
    String? skuName,
    String? categoryName,
    String? categoryUid,
    bool clearCategoryUid = false,
    String? barcode,
    String? skuCode,
    String? costPrice,
    String? sellingPrice,
    String? currency,
    String? unitOfMeasure,
    bool? isSellable,
    String? description,
  }) {
    return SkuFormData(
      skuName: skuName ?? this.skuName,
      categoryName: categoryName ?? this.categoryName,
      categoryUid: clearCategoryUid ? null : (categoryUid ?? this.categoryUid),
      barcode: barcode ?? this.barcode,
      skuCode: skuCode ?? this.skuCode,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      currency: currency ?? this.currency,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      isSellable: isSellable ?? this.isSellable,
      description: description ?? this.description,
    );
  }

  static String _formatPrice(double? value) {
    if (value == null || value <= 0) {
      return '';
    }
    return AppFormatters.formatPrice(value);
  }

  @override
  List<Object?> get props => [
    skuName,
    categoryName,
    categoryUid,
    barcode,
    skuCode,
    costPrice,
    sellingPrice,
    currency,
    unitOfMeasure,
    isSellable,
    description,
  ];
}

class SkuFormState extends Equatable {
  const SkuFormState({
    required this.mode,
    required this.sourceSku,
    required this.initialForm,
    required this.form,
    required this.initialAttributes,
    required this.attributes,
    required this.initialImages,
    required this.images,
    this.status = BaseStatus.initial,
    this.errorMessage,
    this.updatedSku,
  });

  factory SkuFormState.edit(SkuEntity sku) {
    final form = SkuFormData.fromSku(sku);
    final images = _buildImageItems(sku);
    return SkuFormState(
      mode: SkuFormMode.edit,
      sourceSku: sku,
      initialForm: form,
      form: form,
      initialAttributes: List<SkuAttributeEntity>.from(sku.attributes),
      attributes: List<SkuAttributeEntity>.from(sku.attributes),
      initialImages: images,
      images: images,
    );
  }

  factory SkuFormState.create(SkuEntity sku) {
    final form = SkuFormData.createFromSku(sku);
    final attributes = _buildCreateAttributes(sku.attributes);
    return SkuFormState(
      mode: SkuFormMode.create,
      sourceSku: sku,
      initialForm: form,
      form: form,
      initialAttributes: attributes,
      attributes: attributes,
      initialImages: const [],
      images: const [],
    );
  }

  final SkuFormMode mode;
  final SkuEntity sourceSku;
  final SkuFormData initialForm;
  final SkuFormData form;
  final List<SkuAttributeEntity> initialAttributes;
  final List<SkuAttributeEntity> attributes;
  final List<EditableSkuFormImage> initialImages;
  final List<EditableSkuFormImage> images;
  final BaseStatus status;
  final String? errorMessage;
  final SkuEntity? updatedSku;

  String get selectedCategoryName => form.categoryName;

  String? get selectedCategoryUid => form.categoryUid;

  bool get isCreateMode => mode.isCreate;

  bool get areRequiredAttributesComplete {
    if (!isCreateMode) {
      return true;
    }

    return attributes.every(
      (attribute) =>
          attribute.attributeName.trim().isNotEmpty &&
          attribute.value.trim().isNotEmpty,
    );
  }

  bool get hasAttributeChanges => !_listEquals(attributes, initialAttributes);

  bool get hasImageChanges => !_listEquals(images, initialImages);

  bool get hasFormChanges {
    return _normalizeOptionalText(form.barcode) !=
            _normalizeOptionalText(initialForm.barcode) ||
        _normalizeOptionalText(form.skuCode) !=
            _normalizeOptionalText(initialForm.skuCode) ||
        _parsePrice(form.costPrice) != _parsePrice(initialForm.costPrice) ||
        _parsePrice(form.sellingPrice) !=
            _parsePrice(initialForm.sellingPrice) ||
        form.isSellable != initialForm.isSellable;
  }

  bool get hasSavableChanges {
    return hasFormChanges || hasAttributeChanges || hasImageChanges;
  }

  bool get isSubmitting => status == BaseStatus.loading;

  bool get canSubmit {
    if (isSubmitting || !areRequiredAttributesComplete) {
      return false;
    }

    if (isCreateMode) {
      return true;
    }

    return hasSavableChanges;
  }

  List<String> get imageKeys {
    return images
        .map((image) => image.imageKey)
        .where((imageKey) => imageKey.trim().isNotEmpty)
        .toList(growable: false);
  }

  SkuFormState copyWith({
    SkuFormMode? mode,
    SkuEntity? sourceSku,
    SkuFormData? form,
    List<SkuAttributeEntity>? attributes,
    List<EditableSkuFormImage>? images,
    BaseStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    SkuEntity? updatedSku,
    bool clearUpdatedSku = false,
  }) {
    return SkuFormState(
      mode: mode ?? this.mode,
      sourceSku: sourceSku ?? this.sourceSku,
      initialForm: initialForm,
      form: form ?? this.form,
      initialAttributes: initialAttributes,
      attributes: attributes ?? this.attributes,
      initialImages: initialImages,
      images: images ?? this.images,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      updatedSku: clearUpdatedSku ? null : (updatedSku ?? this.updatedSku),
    );
  }

  UpdateSkuParams toUpdateSkuParams({
    required List<String> attributeValueUids,
    SkuEntity? baseSku,
  }) {
    final effectiveSku = baseSku ?? sourceSku;
    return UpdateSkuParams(
      skuUid: effectiveSku.uid,
      version: effectiveSku.version,
      skuCode: form.skuCode.trim().isEmpty ? null : form.skuCode.trim(),
      barCode: form.barcode.trim().isEmpty ? null : form.barcode.trim(),
      sellingPrice: _parsePrice(form.sellingPrice),
      costPrice: _parsePrice(form.costPrice),
      isSellable: form.isSellable,
      attributeValueUids: attributeValueUids,
    );
  }

  AddSkuParams toCreateSkuParams({
    required List<String> attributeValueUids,
    String? skuCode,
  }) {
    final resolvedSkuCode = skuCode ?? form.skuCode.trim();

    return AddSkuParams(
      spuUid: sourceSku.spuUid,
      skuCode: resolvedSkuCode.isEmpty ? null : resolvedSkuCode,
      barCode: form.barcode.trim().isEmpty ? null : form.barcode.trim(),
      sellingPrice: _parsePrice(form.sellingPrice),
      costPrice: _parsePrice(form.costPrice),
      imageKeys: imageKeys,
      isSellable: form.isSellable,
      attributeValueUids: attributeValueUids,
    );
  }

  double? _parsePrice(String value) {
    if (value.trim().isEmpty) {
      return null;
    }
    return AppFormatters.parsePrice(value);
  }

  String? _normalizeOptionalText(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? null : trimmedValue;
  }

  static List<EditableSkuFormImage> _buildImageItems(SkuEntity sku) {
    final items = <EditableSkuFormImage>[];
    final itemCount = sku.imageKeys.length < sku.imageUrls.length
        ? sku.imageKeys.length
        : sku.imageUrls.length;

    for (var index = 0; index < itemCount; index++) {
      items.add(
        EditableSkuFormImage(
          imageKey: sku.imageKeys[index],
          previewPath: sku.imageUrls[index],
          isLocalFile: false,
        ),
      );
    }

    return items;
  }

  static List<SkuAttributeEntity> _buildCreateAttributes(
    List<SkuAttributeEntity> attributes,
  ) {
    final normalizedNames = <String>{};
    final createAttributes = <SkuAttributeEntity>[];

    for (final attribute in attributes) {
      final attributeName = attribute.attributeName.trim();
      final normalizedName = attributeName.toLowerCase();
      if (attributeName.isEmpty || !normalizedNames.add(normalizedName)) {
        continue;
      }

      createAttributes.add(
        SkuAttributeEntity(
          uid: attribute.uid,
          attributeName: attributeName,
          value: '',
        ),
      );
    }

    return createAttributes;
  }

  bool _listEquals<T>(List<T> first, List<T> second) {
    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }

  @override
  List<Object?> get props => [
    mode,
    sourceSku,
    initialForm,
    form,
    initialAttributes,
    attributes,
    initialImages,
    images,
    status,
    errorMessage,
    updatedSku,
  ];
}
