import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/core/widgets/loader/app_loader_backdrop_filter.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';
import 'package:ventry_flutter/presentation/screens/add_product/utils/product_unit_validation.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/product_unit_setup_section.dart';

class AddProductUnitSetupPage extends StatefulWidget {
  const AddProductUnitSetupPage({super.key, required this.bloc});

  final AddProductBloc bloc;

  @override
  State<AddProductUnitSetupPage> createState() =>
      _AddProductUnitSetupPageState();
}

class _AddProductUnitSetupPageState extends State<AddProductUnitSetupPage> {
  bool _isCompleting = false;

  AddProductBloc get bloc => widget.bloc;

  Future<void> _complete(BuildContext context) async {
    final inputError = validateAddProductUnits(
      bloc.state,
      allowPendingUnitIds: true,
    );
    if (inputError != null) {
      AppSnackBar.showError(context, inputError);
      return;
    }

    setState(() => _isCompleting = true);
    final persistError = await _persistPendingUnits();
    if (!context.mounted) return;
    setState(() => _isCompleting = false);
    if (persistError != null) {
      AppSnackBar.showError(context, persistError);
      return;
    }

    final error = validateAddProductUnits(bloc.state);
    if (error != null) {
      AppSnackBar.showError(context, error);
      return;
    }
    Navigator.of(context).pop();
  }

  Future<String?> _persistPendingUnits() async {
    final baseUnit = bloc.state.selectedBaseUnit;
    if (baseUnit != null && baseUnit.id <= 0) {
      bloc.add(CreateProductUnitEvent(baseUnit.name));
      final state = await _waitUnitRequest();
      if (state.selectedBaseUnit?.id == baseUnit.id) {
        return _createFailedMessage();
      }
    }

    final pendingDrafts = bloc.state.productUnitDrafts
        .where(
          (draft) => draft.unit.id <= 0 && draft.unit.name.trim().isNotEmpty,
        )
        .toList();
    for (final draft in pendingDrafts) {
      bloc.add(
        CreateProductUnitEvent(
          draft.unit.name,
          selectAsBase: false,
          draftId: draft.id,
        ),
      );
      final state = await _waitUnitRequest();
      final updatedDraft = state.productUnitDrafts
          .where((item) => item.id == draft.id)
          .firstOrNull;
      if (updatedDraft == null || updatedDraft.unit.id == draft.unit.id) {
        return _createFailedMessage();
      }
    }
    return null;
  }

  Future<AddProductState> _waitUnitRequest() {
    return bloc.stream.firstWhere(
      (state) => state.unitStatus != BaseStatus.loading,
    );
  }

  String _createFailedMessage() {
    return bloc.state.errorMessage ?? AppStrings.productUnitInvalidConversion;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: AppLoaderBackdropFilter(
        isLoading: _isCompleting,
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          appBar: AppTopBar(
            title: AppStrings.productUnitSetupTitle,
            leadingWidget: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: AppSize.size16.r,
              ),
              onPressed: _isCompleting
                  ? null
                  : () => Navigator.of(context).pop(),
            ),
            trailingWidget: TextButton(
              onPressed: _isCompleting ? null : () => _complete(context),
              child: Text(
                AppStrings.productUnitDone,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.size16.r,
              vertical: AppSize.size12.r,
            ),
            children: const [ProductUnitSetupSection()],
          ),
        ),
      ),
    );
  }
}
