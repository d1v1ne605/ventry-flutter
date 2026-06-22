import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/presentation/screens/login/bloc/login_event.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';

/// Login submit button that reacts to [LoginBloc] state.
///
/// Shows a loading indicator while authentication is in progress
/// and displays a [SnackBar] on success or failure.
class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStateChanged,
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.login.submitButton,
          isLoading: state.status == LoginStatus.loading,
          icon: const Icon(
            Icons.login,
            color: Colors.white,
            size: AppSize.size16,
          ),
          onPressed: () =>
              context.read<LoginBloc>().add(const LoginSubmitted()),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.failure) {
      AppSnackBar.showError(
        context,
        state.errorMessage ?? AppStrings.login.errorDefault,
      );
    } else if (state.status == LoginStatus.success) {
      AppSnackBar.showSuccess(context, AppStrings.login.successMessage);
    }
  }
}
