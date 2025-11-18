// lib/users/presentation/view/user_view.dart

import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/users/presentation/cubit/user_cubit.dart';
import 'package:catalog_admin/features/users/presentation/cubit/user_state.dart';
import 'package:country_picker/country_picker.dart'; // ✅ استيراد country_picker
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});
  static const String routeName = '/usersView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserCubit>()..loadUsers(),
      child: const _UsersViewBody(),
    );
  }
}

class _UsersViewBody extends StatelessWidget {
  const _UsersViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              _buildHeaderCard(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.w),
                  child: Column(
                    children: [
                      _buildFilters(context),
                      SizedBox(height: 20.h),
                      _buildUsersList(),
                      _buildPagination(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        int totalUsers = 0;
        if (state is UserLoaded) {
          totalUsers = state.totalCount;
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF5F5FF9),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.r,
                child: Image.asset(
                  ImageAssets.contactIcon,
                  height: 40.h,
                  width: 40.w,
                  color: const Color(0xFF5F5FF9),
                ),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Users',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    '$totalUsers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final cubit = context.read<UserCubit>();

        return Column(
          children: [
            // ✅ Country Filter - استخدام country_picker
            GestureDetector(
              onTap: () => _showCountryPicker(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1F1FF),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFF5F5FF9).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Country: ${cubit.selectedCountry}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF00796B),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFF00796B),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),

            // Search Field
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search By User/Name/Phone/Email',
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff5E6171),
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color(0xff5E6171),
                  ),
                ),
                onChanged: (value) {
                  cubit.updateSearchQuery(value);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ استخدام country_picker بدلاً من القائمة الثابتة
  void _showCountryPicker(BuildContext context) {
    final cubit = context.read<UserCubit>();

    // ✅ إضافة خيار "All Countries" يدوياً
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Select Country',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5F5FF9),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            height: 400.h,
            child: Column(
              children: [
                // ✅ خيار "All Countries"
                ListTile(
                  leading: Text('🌍', style: TextStyle(fontSize: 24.sp)),
                  title: Text(
                    'All Countries',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: cubit.selectedCountry == 'All'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: cubit.selectedCountry == 'All'
                          ? const Color(0xFF5F5FF9)
                          : Colors.black,
                    ),
                  ),
                  trailing: cubit.selectedCountry == 'All'
                      ? Icon(
                          Icons.check_circle,
                          color: const Color(0xFF5F5FF9),
                          size: 20.sp,
                        )
                      : null,
                  onTap: () {
                    cubit.updateCountry('All');
                    Navigator.pop(dialogContext);
                  },
                ),
                Divider(height: 1.h, thickness: 1),

                // ✅ زر لفتح country_picker
                Expanded(
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext); // إغلاق الـ Dialog الحالي

                        // ✅ فتح country_picker
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          countryListTheme: CountryListThemeData(
                            flagSize: 25,
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                            bottomSheetHeight: 500.h,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Start typing to search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                    0xFF5F5FF9,
                                  ).withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) {
                            // ✅ استخدام اسم الدولة فقط
                            cubit.updateCountry(country.name);
                          },
                        );
                      },
                      icon: const Icon(Icons.public, color: Colors.white),
                      label: Text(
                        'Select from all countries',
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F5FF9),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        );
      },
    );
  }

  Widget _buildUsersList() {
    return Expanded(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5F5FF9)),
            );
          }

          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60.sp,
                    color: Colors.red.shade300,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'No Users Found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Try adjusting your filters',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Container(
                  padding: EdgeInsets.all(15.w),
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Username Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff5E6171),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF5F5FF9,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '@${user.username}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF5F5FF9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Phone
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              user.phone,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xff5E6171),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),

                      // Email
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xff5E6171),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Provider Badge (if exists)
                      if (user.provider != null) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user,
                                size: 12.sp,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                user.provider!.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final cubit = context.read<UserCubit>();
        final canGoBack = cubit.currentPage > 1;
        final canGoForward = state is UserLoaded && state.users.isNotEmpty;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Page Button
              GestureDetector(
                onTap: canGoBack ? () => cubit.goToPreviousPage() : null,
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: canGoBack ? Colors.grey : Colors.grey.shade300,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),

              // Current Page Number
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  '${cubit.currentPage}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Next Page Button
              GestureDetector(
                onTap: canGoForward ? () => cubit.goToNextPage() : null,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: canGoForward ? Colors.grey : Colors.grey.shade300,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
