// lib/auth/presentation/view/splash_view.dart

import 'dart:async';
import 'package:catalog_admin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:catalog_admin/features/auth/presentation/view/login_view.dart';
import 'package:catalog_admin/core/common/navigator_helper.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/home/presentation/view/main_layout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>()..checkAuthStatus(),
      child: const SplashViewBody(),
    );
  }
}

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  late Timer _timer;

  void _startDelay() {
    _timer = Timer(const Duration(seconds: 3), () {
      // Timer will be handled by BlocListener
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // User is already logged in
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              navigatePushReplacementNamed(context, MainLayout.routeName);
            }
          });
        } else if (state is AuthUnauthenticated) {
          // User needs to login
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              navigatePushReplacementNamed(context, LoginView.routeName);
            }
          });
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageAssets.backgroundSplash),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 287.w,
              height: 160.h,
              child: Image.asset(ImageAssets.logoApp, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
