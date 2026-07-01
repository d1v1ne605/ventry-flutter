import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_params.dart';

class EditSkuFormData extends Equatable {
  const EditSkuFormData({
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

  factory EditSkuFormData.fromSku(SkuEntity sku) {
    return EditSkuFormData(
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

  EditSkuFormData copyWith({
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
    return EditSkuFormData(
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

class EditSkuState extends Equatable {
  const EditSkuState({
    required this.sourceSku,
    required this.initialForm,
    required this.form,
    this.status = BaseStatus.initial,
    this.errorMessage,
    this.updatedSku,
  });

  factory EditSkuState.fromSku(SkuEntity sku) {
    final form = EditSkuFormData.fromSku(sku);
    return EditSkuState(sourceSku: sku, initialForm: form, form: form);
  }

  final SkuEntity sourceSku;
  final EditSkuFormData initialForm;
  final EditSkuFormData form;
  final BaseStatus status;
  final String? errorMessage;
  final SkuEntity? updatedSku;

  String get selectedCategoryName => form.categoryName;

  String? get selectedCategoryUid => form.categoryUid;

  bool get hasSavableChanges {
    return _normalizeOptionalText(form.barcode) !=
            _normalizeOptionalText(initialForm.barcode) ||
        _normalizeOptionalText(form.skuCode) !=
            _normalizeOptionalText(initialForm.skuCode) ||
        _parsePrice(form.costPrice) != _parsePrice(initialForm.costPrice) ||
        _parsePrice(form.sellingPrice) !=
            _parsePrice(initialForm.sellingPrice) ||
        form.isSellable != initialForm.isSellable;
  }

  bool get isSubmitting => status == BaseStatus.loading;

  EditSkuState copyWith({
    SkuEntity? sourceSku,
    EditSkuFormData? form,
    BaseStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    SkuEntity? updatedSku,
    bool clearUpdatedSku = false,
  }) {
    return EditSkuState(
      sourceSku: sourceSku ?? this.sourceSku,
      initialForm: initialForm,
      form: form ?? this.form,
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

  @override
  List<Object?> get props => [
    sourceSku,
    initialForm,
    form,
    status,
    errorMessage,
    updatedSku,
  ];
}
