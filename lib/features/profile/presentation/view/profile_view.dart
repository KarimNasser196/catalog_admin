// lib/profile/presentation/view/profile_view.dart

import 'package:catalog_admin/core/common/custom_snackbar.dart';
import 'package:catalog_admin/core/common/navigator_helper.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/widgets/custom_textfield_widget.dart';
import 'package:catalog_admin/features/auth/presentation/view/login_view.dart';
import 'package:catalog_admin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String routeName = '/profileView';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: const ProfileViewBody(),
    );
  }
}

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // ✅ At least 8 characters
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // ✅ Must contain at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // ✅ Must contain at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // ✅ Must contain at least one symbol/special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one symbol (!@#\$%^&*...)';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          showCustomSnackBar(context, 'Profile updated! Please login again.');

          // Navigate to login
          Future.delayed(const Duration(seconds: 1), () {
            navigatePushReplacementNamed(context, LoginView.routeName);
          });
        } else if (state is ProfileError) {
          showCustomSnackBar(context, state.message, isError: true);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),

                        // Email Field
                        CustomTextFormField(
                          controller: _emailController,
                          labelWidget: Text(
                            'Login User',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          hint: 'example@example.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),

                        SizedBox(height: 25.h),

                        // Password Field
                        CustomTextFormField(
                          controller: _passwordController,
                          labelWidget: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          hint: '••••••••••••',
                          obscureText: true,
                          validator: _validatePassword,
                        ),

                        // ✅ Password Requirements Hint
                        Padding(
                          padding: EdgeInsets.only(top: 8.h, left: 4.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '• At least 8 characters\n'
                              '• One uppercase & one lowercase letter\n'
                              '• At least one symbol (!@#\$%...)',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 25.h),

                        // Confirm Password Field
                        CustomTextFormField(
                          controller: _confirmPasswordController,
                          labelWidget: Text(
                            'Confirm Password Again',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          hint: '••••••••••••',
                          obscureText: true,
                          validator: _validateConfirmPassword,
                        ),

                        // Dynamic spacing
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),

                        // Save Changes Button
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            final isLoading = state is ProfileLoading;

                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 30.h),
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _saveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF6823),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  elevation: 0,
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
                                        'Save Change',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
