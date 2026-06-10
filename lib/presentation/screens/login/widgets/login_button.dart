import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
import '../bloc/login_status.dart';
import '../bloc/login_submitted.dart';

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
          text: 'Login',
          isLoading: state.status == LoginStatus.loading,
          icon: const Icon(Icons.login, color: Colors.white, size: 16),
          onPressed: () => context.read<LoginBloc>().add(const LoginSubmitted()),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Authentication Failed')),
      );
    } else if (state.status == LoginStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
    }
  }
}
