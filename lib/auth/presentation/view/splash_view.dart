import 'dart:async';

import 'package:catalog_admin/auth/presentation/view/login_view.dart';
import 'package:catalog_admin/core/common/navigator_helper.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';

import 'package:catalog_admin/home/presentation/view/main_layout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Import flutter_screenutil

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String routeName = '/';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer _timer;
  _startDelay() {
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() {
    navigatePushReplacementNamed(context, LoginView.routeName);
  }

  @override
  void initState() {
    _startDelay();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
