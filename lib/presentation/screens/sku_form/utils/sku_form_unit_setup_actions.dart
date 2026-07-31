import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_bloc.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_unit_draft.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/utils/sku_form_unit_helpers.dart';

class SkuFormUnitSetupActions {
  const SkuFormUnitSetupActions._();

  static void addDraft(BuildContext context, SkuFormState state) {
    if (baseUnitSkuForVariant(state) == null) {
      AppSnackBar.showError(context, AppStrings.productUnitBaseFirst);
      return;
    }

    context.read<SkuFormBloc>().add(
      SkuFormUnitDraftAdded(
        SkuFormUnitDraft(
          id: const Uuid().v4(),
          unit: UnitEntity(
            id: -DateTime.now().microsecondsSinceEpoch,
            name: '',
          ),
          skuCode: '',
          conversionFactor: 0,
          sellingPrice: 0,
        ),
      ),
    );
  }

  static void changeDraftUnitName(
    BuildContext context,
    SkuFormState state,
    SkuFormUnitDraft draft,
    String value,
  ) {
    final fallbackId = draft.unit.id < 0
        ? draft.unit.id
        : -DateTime.now().microsecondsSinceEpoch;
    context.read<SkuFormBloc>().add(
      SkuFormUnitDraftChanged(
        id: draft.id,
        unit: unitFromText(
          availableUnitsForDraft(state, draft),
          value,
          fallbackId,
        ),
      ),
    );
  }

  static void changeDraftFactor(
    BuildContext context,
    SkuFormState state,
    SkuFormUnitDraft draft,
    double factor,
  ) {
    final basePrice = baseUnitSkuForVariant(state)?.sellingPrice ?? 0;
    final currentAutoPrice = basePrice * draft.conversionFactor;
    final shouldRefreshPrice =
        draft.sellingPrice == 0 || draft.sellingPrice == currentAutoPrice;
    context.read<SkuFormBloc>().add(
      SkuFormUnitDraftChanged(
        id: draft.id,
        conversionFactor: factor,
        sellingPrice: shouldRefreshPrice ? basePrice * factor : null,
      ),
    );
  }

  static void changeCurrentUnitName(
    BuildContext context,
    SkuFormState state,
    String value,
  ) {
    final currentUnit = state.currentUnitEdit.unit ?? state.sourceSku.unit;
    final fallbackId = currentUnit != null && currentUnit.id < 0
        ? currentUnit.id
        : -DateTime.now().microsecondsSinceEpoch;
    context.read<SkuFormBloc>().add(
      SkuFormCurrentUnitChanged(
        state.currentUnitEdit.copyWith(
          unit: unitFromText(state.units, value, fallbackId),
        ),
      ),
    );
  }

  static void changeCurrentFactor(
    BuildContext context,
    SkuFormState state,
    double factor,
  ) {
    context.read<SkuFormBloc>().add(
      SkuFormCurrentUnitChanged(
        state.currentUnitEdit.copyWith(conversionFactor: factor),
      ),
    );
  }

  static void changeCurrentPrice(
    BuildContext context,
    SkuFormState state,
    double price,
  ) {
    context.read<SkuFormBloc>().add(
      SkuFormCurrentUnitChanged(
        state.currentUnitEdit.copyWith(sellingPrice: price),
      ),
    );
  }

  static void removeCurrentUnit(BuildContext context, SkuFormState state) {
    context.read<SkuFormBloc>().add(
      SkuFormCurrentUnitChanged(
        state.currentUnitEdit.copyWith(isRemoved: true),
      ),
    );
  }
}
