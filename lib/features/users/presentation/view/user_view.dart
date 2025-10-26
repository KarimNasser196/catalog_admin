import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:catalog_admin/features/users/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});
  static const String routeName = '/usersView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserCubit>()
        ..loadUsers()
        ..loadUsers(),
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
              Container(
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
                          'User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              return Text(
                                '${state.users.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

  Widget _buildFilters(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Show country picker dialog
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD1F1FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Country: ${cubit.selectedCountry}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF00796B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF00796B),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
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
              suffixIcon: const Icon(Icons.search, color: Color(0xff5E6171)),
            ),
            onChanged: (value) {
              cubit.updateSearchQuery(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUsersList() {
    return Expanded(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            );
          }

          if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return Center(
                child: Text(
                  'No users found',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
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
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5E6171),
                            ),
                          ),
                          Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff5E6171),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.phone,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff5E6171),
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff5E6171),
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

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => cubit.goToPreviousPage(),
            child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              '${cubit.currentPage}',
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () => cubit.goToNextPage(),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
