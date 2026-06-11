import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_size.dart';
import '../../../injection.dart';
import 'bloc/login_bloc.dart';
import 'widgets/login_card.dart';

/// Entry point for the Login screen.
///
/// Provides [LoginBloc] to the subtree and renders the scrollable
/// scaffold with [LoginCard] as the main content.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size16.w,
                vertical: AppSize.size20.h,
              ),
              child: const LoginCard(),
            ),
          ),
        ),
      ),
    );
  }
}
