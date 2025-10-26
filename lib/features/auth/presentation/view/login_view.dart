// lib/auth/presentation/view/login_view.dart

import 'package:catalog_admin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:catalog_admin/core/common/custom_snackbar.dart';
import 'package:catalog_admin/core/common/navigator_helper.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/core/widgets/custom_textfield_widget.dart';
import 'package:catalog_admin/home/presentation/view/main_layout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = '/loginView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: const LoginViewBody(),
    );
  }
}

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      context.read<AuthCubit>().login(
        emailOrPhone: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                navigatePushReplacementNamed(context, MainLayout.routeName);
              } else if (state is AuthError) {
                showCustomSnackBar(context, 'Login failed', isError: true);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        /// Logo
                        Image.asset(ImageAssets.logoApp, height: 150.h),
                        Image.asset(ImageAssets.line, height: 12.h),
                        SizedBox(height: 40.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff3A34FE),
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),

                        /// Email or Mobile Number
                        CustomTextFormField(
                          controller: _emailController,
                          labelWidget: Text(
                            'Email or Mobile Number',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          hint: 'example@example.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email or Mobile Number is required';
                            }
                            // Basic validation for email or mobile
                            if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value) &&
                                !RegExp(r'^\d{10,15}$').hasMatch(value)) {
                              return 'Invalid Email or Mobile Number';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15.h),

                        /// Password
                        CustomTextFormField(
                          controller: _passwordController,
                          labelWidget: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          hint: '********',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 30.h),

                        /// Login button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff5F5FF9),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
