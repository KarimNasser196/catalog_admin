import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:catalog_admin/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final cubit = context.read<TransactionCubit>();

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
            SizedBox(width: 15.w),
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
        SizedBox(height: 15.h),
        _buildFilterBox(
          'Country: ${cubit.selectedCountry}',
          onTap: () {
            // TODO: Implement country picker
          },
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

  Widget _buildFilterBox(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            );
          }

          if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return Center(
                child: Text(
                  'No transactions found',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
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
                          ...transaction.tags.map((tag) {
                            return Container(
                              margin: EdgeInsets.only(right: 5.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: tag == 'Text'
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
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
    final cubit = context.read<TransactionCubit>();

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
