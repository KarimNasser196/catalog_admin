import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        final cubit = context.read<PaymentCubit>();

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFilterBox(
                    cubit.startDate,
                    onTap: () => _showDatePicker(
                      context,
                      isStartDate: true,
                      currentDate: cubit.startDate,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildFilterBox(
                    cubit.endDate,
                    onTap: () => _showDatePicker(
                      context,
                      isStartDate: false,
                      currentDate: cubit.endDate,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildFilterBox(
              "Country : ${cubit.selectedCountry}",
              onTap: () => _showCountryPicker(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDatePicker(
    BuildContext context, {
    required bool isStartDate,
    required String currentDate,
  }) async {
    final cubit = context.read<PaymentCubit>();

    // Parse current date or use today
    DateTime initialDate = DateTime.now();
    try {
      initialDate = DateFormat('dd MMM yyyy').parse(currentDate);
    } catch (e) {
      // Use current date if parsing fails
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5F5FF9),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd MMM yyyy').format(picked);
      if (isStartDate) {
        cubit.updateStartDate(formattedDate);
      } else {
        cubit.updateEndDate(formattedDate);
      }
    }
  }

  Future<void> _showCountryPicker(BuildContext context) async {
    final cubit = context.read<PaymentCubit>();

    final List<Map<String, String>> countries = [
      {'name': 'Egypt', 'flag': '🇪🇬'},
      {'name': 'Saudi Arabia', 'flag': '🇸🇦'},
      {'name': 'UAE', 'flag': '🇦🇪'},
      {'name': 'Kuwait', 'flag': '🇰🇼'},
      {'name': 'Jordan', 'flag': '🇯🇴'},
      {'name': 'Lebanon', 'flag': '🇱🇧'},
      {'name': 'Oman', 'flag': '🇴🇲'},
      {'name': 'Qatar', 'flag': '🇶🇦'},
      {'name': 'Bahrain', 'flag': '🇧🇭'},
      {'name': 'Iraq', 'flag': '🇮🇶'},
      {'name': 'Palestine', 'flag': '🇵🇸'},
      {'name': 'Morocco', 'flag': '🇲🇦'},
      {'name': 'Algeria', 'flag': '🇩🇿'},
      {'name': 'Tunisia', 'flag': '🇹🇳'},
    ];

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Select Country',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5F5FF9),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              final isSelected = cubit.selectedCountry == country['name'];

              return ListTile(
                leading: Text(
                  country['flag']!,
                  style: TextStyle(fontSize: 24.sp),
                ),
                title: Text(
                  country['name']!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? const Color(0xFF5F5FF9) : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: const Color(0xFF5F5FF9),
                        size: 20.sp,
                      )
                    : null,
                onTap: () {
                  cubit.updateCountry(country['name']!);
                  Navigator.pop(dialogContext);
                },
              );
            },
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
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
          border: Border.all(
            color: const Color(0xFF5F5FF9).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff5E6171),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 60.sp,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'No payments found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
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
            onTap: cubit.currentPage > 1
                ? () => cubit.goToPreviousPage()
                : null,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: cubit.currentPage > 1 ? Colors.grey : Colors.grey.shade300,
            ),
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
