// lib/home/presentation/view/dashboard_view.dart
import 'package:catalog_admin/core/common/navigator_helper.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/payment/presentation/view/payment_view.dart';
import 'package:catalog_admin/features/promo/presentation/view/promo_view.dart';
import 'package:catalog_admin/features/subscription/presentation/view/subscription_view.dart';
import 'package:catalog_admin/features/transactions/presentation/view/transaction_view.dart';
import 'package:catalog_admin/features/users/presentation/view/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  static const String routeName = '/dashboardView';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Earned Card
          Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Earned',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '65,845 EGP',
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
          ),
          SizedBox(height: 15.h),
          // Total Users Card
          Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Users',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '1524',
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
          ),
          SizedBox(height: 40.h),
          // Grid of Options - Now 2x3 with Promo Code
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 20.h,
              shrinkWrap: true,
              childAspectRatio: 1.0,
              physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                // NEW: Promo Code Icon
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
            radius: 50.r,
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
