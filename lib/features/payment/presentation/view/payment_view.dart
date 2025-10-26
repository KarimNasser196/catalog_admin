import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});
  static const String routeName = '/paymentsView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentCubit>()..loadPayments(),
      child: const _PaymentsViewBody(),
    );
  }
}

class _PaymentsViewBody extends StatelessWidget {
  const _PaymentsViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              _buildHeaderCard(context),
              SizedBox(height: 20.h),
              _buildFilters(context),
              SizedBox(height: 20.h),
              _buildPaymentTable(context),
              SizedBox(height: 14.h),
              _buildPagination(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF5F5FF9),
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
              BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  final cubit = context.read<PaymentCubit>();
                  return Text(
                    cubit.totalEarned,
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
    );
  }

  Widget _buildFilters(BuildContext context) {
    final cubit = context.read<PaymentCubit>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFilterBox(
                cubit.startDate,
                onTap: () {
                  // TODO: Implement date picker
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildFilterBox(
                cubit.endDate,
                onTap: () {
                  // TODO: Implement date picker
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        _buildFilterBox(
          "Country : ${cubit.selectedCountry}",
          onTap: () {
            // TODO: Implement country picker
          },
        ),
      ],
    );
  }

  Widget _buildFilterBox(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xff5E6171)),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: const Color(0xff5E6171),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTable(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Amount",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  if (state is PaymentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PaymentError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    );
                  }

                  if (state is PaymentLoaded) {
                    if (state.payments.isEmpty) {
                      return Center(
                        child: Text(
                          'No payments found',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.payments.length,
                      itemBuilder: (context, index) {
                        final payment = state.payments[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 15.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  payment.user,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xff5E6171),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  payment.date,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xff5E6171),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  payment.amount,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xff5E6171),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    final cubit = context.read<PaymentCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => cubit.goToPreviousPage(),
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
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
            child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
