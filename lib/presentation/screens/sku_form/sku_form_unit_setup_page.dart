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
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_bloc.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_unit_setup_section.dart';

class SkuFormUnitSetupPage extends StatelessWidget {
  const SkuFormUnitSetupPage({super.key, required this.bloc});

  final SkuFormBloc bloc;

  void _complete(BuildContext context) {
    final state = context.read<SkuFormBloc>().state;
    if (!state.hasUnitChanges) {
      Navigator.of(context).pop(false);
      return;
    }
    context.read<SkuFormBloc>().add(const SkuFormUnitConfigurationSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<SkuFormBloc, SkuFormState>(
        listenWhen: (previous, current) =>
            previous.unitStatus != current.unitStatus ||
            previous.unitConfigurationSaved != current.unitConfigurationSaved,
        listener: (context, state) {
          if (state.unitStatus == BaseStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
            return;
          }

          if (state.unitConfigurationSaved) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          return AppLoaderBackdropFilter(
            isLoading: state.isUnitSubmitting,
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
                  onPressed: state.isUnitSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                trailingWidget: TextButton(
                  onPressed: state.isUnitSubmitting
                      ? null
                      : () => _complete(context),
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
                children: const [SkuFormUnitSetupSection()],
              ),
            ),
          );
        },
      ),
    );
  }
}
