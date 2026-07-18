import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../routes/router_constants.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_state.dart';
import '../bloc/register_submitted.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStateChanged,
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.register.createButton,
          isLoading: state.status == BaseStatus.loading,
          icon: const Icon(
            Icons.person_add_alt_1,
            color: Colors.white,
            size: AppSize.size16,
          ),
          onPressed: () {
            context.read<RegisterBloc>().add(const RegisterSubmitted());
          },
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, RegisterState state) {
    if (state.status == BaseStatus.failure) {
      AppSnackBar.showError(
        context,
        state.errorMessage ?? AppStrings.register.errorDefault,
      );
      return;
    }

    if (state.status == BaseStatus.success) {
      AppSnackBar.showSuccess(context, AppStrings.register.successMessage);
      context.goNamed(RouterName.login);
    }
  }
}
