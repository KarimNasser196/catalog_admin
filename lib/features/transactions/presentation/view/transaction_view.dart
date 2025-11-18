import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});
  static const String routeName = '/transactionsView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionCubit>()..loadTransactions(),
      child: const _TransactionsViewBody(),
    );
  }
}

class _TransactionsViewBody extends StatelessWidget {
  const _TransactionsViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF6823),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30.r,
                      child: Image.asset(
                        ImageAssets.transactionIcon,
                        height: 40.h,
                        width: 40.w,
                        color: const Color(0xFFEF6823),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<TransactionCubit, TransactionState>(
                          builder: (context, state) {
                            if (state is TransactionLoaded) {
                              return Text(
                                '${state.transactions.length}',
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
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Column(
                    children: [
                      _buildFilters(context),
                      SizedBox(height: 20.h),
                      _buildTableHeader(),
                      SizedBox(height: 10.h),
                      _buildTransactionsList(),
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
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final cubit = context.read<TransactionCubit>();

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFilterBox(
                    context,
                    cubit.startDate,
                    onTap: () => _showDatePicker(
                      context,
                      isStartDate: true,
                      currentDate: cubit.startDate,
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _buildFilterBox(
                    context,
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
            SizedBox(height: 15.h),
            _buildFilterBox(
              context,
              'Country: ${cubit.selectedCountry}',
              onTap: () => _showCountryPicker(context),
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
                  hintText: 'Search By User Name',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
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

  Future<void> _showDatePicker(
    BuildContext context, {
    required bool isStartDate,
    required String currentDate,
  }) async {
    final cubit = context.read<TransactionCubit>();

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
              primary: Color(0xFFEF6823),
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
    final cubit = context.read<TransactionCubit>();

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
            color: const Color(0xFFEF6823),
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
                    color: isSelected ? const Color(0xFFEF6823) : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: const Color(0xFFEF6823),
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

  Widget _buildFilterBox(
    BuildContext context,
    String text, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xFFEF6823).withValues(alpha: 0.2),
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

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Sender',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Received',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEF6823)),
            );
          }

          if (state is TransactionError) {
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

          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 80.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'No Transactions Found',
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
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
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
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              transaction.sender,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              transaction.date,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              transaction.receiver,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          // Status badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: transaction.status == 'Successful'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              transaction.status,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          // Message Type Tags - All 4 types always shown
                          _buildMessageTypeTag('Text', transaction.tags),
                          SizedBox(width: 4.w),
                          _buildMessageTypeTag('Image', transaction.tags),
                          SizedBox(width: 4.w),
                          _buildMessageTypeTag('Video', transaction.tags),
                          SizedBox(width: 4.w),
                          _buildMessageTypeTag('Voice', transaction.tags),
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

  // Helper method to build message type tags
  // Blue if the type was sent, grey if not
  Widget _buildMessageTypeTag(String type, List<String> sentTypes) {
    final bool wasSent = sentTypes.contains(type);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: wasSent ? Colors.blue : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPagination(BuildContext context) {
    final cubit = context.read<TransactionCubit>();

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
