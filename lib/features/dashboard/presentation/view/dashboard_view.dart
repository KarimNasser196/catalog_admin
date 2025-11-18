// lib/home/presentation/view/dashboard_view.dart

import 'package:catalog_admin/core/common/navigator_helper.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:catalog_admin/features/payment/presentation/view/payment_view.dart';
import 'package:catalog_admin/features/promo/presentation/view/promo_view.dart';
import 'package:catalog_admin/features/subscription/presentation/view/subscription_view.dart';
import 'package:catalog_admin/features/transactions/presentation/view/transaction_view.dart';
import 'package:catalog_admin/features/users/presentation/view/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  static const String routeName = '/dashboardView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..loadDashboardStats(),
      child: const DashboardViewBody(),
    );
  }
}

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total Earned Card
              _buildTotalEarnedCard(state),

              SizedBox(height: 15.h),

              // Total Users Card
              _buildTotalUsersCard(state),

              SizedBox(height: 40.h),

              // Grid of Options
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  shrinkWrap: true,
                  childAspectRatio: 1.0,
                  physics: const ScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [
                    _buildOptionIcon(
                      context,
                      ImageAssets.coinIcon,
                      'Payments',
                      () => navigatePush(context, const PaymentsView()),
                    ),
                    _buildOptionIcon(
                      context,
                      ImageAssets.transactionIcon,
                      'Transaction',
                      () => navigatePush(context, const TransactionsView()),
                    ),
                    _buildOptionIcon(
                      context,
                      ImageAssets.subscriptionIcon,
                      'Subscription',
                      () => navigatePush(context, const SubscriptionsView()),
                    ),
                    _buildOptionIcon(
                      context,
                      ImageAssets.profileIcon,
                      'Users',
                      () => navigatePush(context, const UsersView()),
                    ),
                    _buildOptionIconWithIconData(
                      context,
                      Icons.local_offer_outlined,
                      'Promo Codes',
                      Colors.black38,
                      () => navigatePush(context, const PromoView()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalEarnedCard(DashboardState state) {
    String displayValue = '0.00 EGP';
    bool isLoading = state is DashboardLoading || state is DashboardInitial;

    if (state is DashboardLoaded) {
      displayValue = '${state.stats.totalEarned.toStringAsFixed(2)} EGP';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF5F5FF9), // Purple color
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF5F5FF9),
            radius: 40.r,
            child: Image.asset(
              ImageAssets.dollarIcon,
              height: 80.h,
              width: 80.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Earned',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                isLoading
                    ? SizedBox(
                        height: 30.h,
                        width: 30.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        displayValue,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalUsersCard(DashboardState state) {
    String displayValue = '0';
    bool isLoading = state is DashboardLoading || state is DashboardInitial;

    if (state is DashboardLoaded) {
      displayValue = state.stats.totalUsers.toString();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEF6823), // Orange color
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEF6823),
            radius: 40.r,
            child: Image.asset(
              ImageAssets.userCircle,
              height: 80.h,
              width: 80.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Users',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                isLoading
                    ? SizedBox(
                        height: 30.h,
                        width: 30.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        displayValue,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionIcon(
    BuildContext context,
    String iconPath,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFD1F1FF), // Light blue
            radius: 50.r,
            child: Image.asset(iconPath, height: 60.h, width: 60.w),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xff444050)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionIconWithIconData(
    BuildContext context,
    IconData icon,
    String label,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFD1F1FF), // Light blue
            radius: 40.r,
            child: Icon(icon, size: 50.sp, color: iconColor),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xff444050)),
          ),
        ],
      ),
    );
  }
}
