import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';

String? validateAddProductUnits(
  AddProductState state, {
  bool allowPendingUnitIds = false,
}) {
  if (state.selectedBaseUnit == null && state.productUnitDrafts.isEmpty) {
    return null;
  }
  if (state.selectedBaseUnit == null ||
      state.selectedBaseUnit!.name.trim().isEmpty) {
    return AppStrings.productUnitBaseRequired;
  }
  if (!allowPendingUnitIds && state.selectedBaseUnit!.id <= 0) {
    return AppStrings.productUnitBaseRequired;
  }
  if (state.productUnitDrafts.any(
    (draft) =>
        draft.unit.name.trim().isEmpty ||
        (!allowPendingUnitIds && draft.unit.id <= 0) ||
        draft.conversionFactor <= 0,
  )) {
    return AppStrings.productUnitInvalidConversion;
  }

  final unitIds = <int>{state.selectedBaseUnit!.id};
  final unitNames = <String>{_normalizeUnitName(state.selectedBaseUnit!.name)};
  for (final draft in state.productUnitDrafts) {
    if (draft.unit.id > 0 && !unitIds.add(draft.unit.id)) {
      return AppStrings.productUnitDuplicate;
    }
    if (!unitNames.add(_normalizeUnitName(draft.unit.name))) {
      return AppStrings.productUnitDuplicate;
    }
  }
  return null;
}

String _normalizeUnitName(String value) => value.trim().toLowerCase();
