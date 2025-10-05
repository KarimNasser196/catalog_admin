import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentsView extends StatefulWidget {
  const PaymentsView({super.key});
  static const String routeName = '/paymentsView';

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  String startDate = '14 Aug 2025';
  String endDate = '17 Sep 2027';
  String selectedCountry = 'Egypt';

  final List<Map<String, String>> paymentData = [
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,200 EGP'},
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,200 EGP'},
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,240 EGP'},
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,200 EGP'},
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,200 EGP'},
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,200 EGP'},
    {'user': '@mahran', 'date': '12-10-2025', 'amount': '1,200 EGP'},
  ];

  int currentPage = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              // Top Card
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF5F5FF9), // Purple color
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF5F5FF9),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
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
              SizedBox(height: 20.h),

              // Filters
              Row(
                children: [
                  Expanded(child: _buildFilterBox(startDate)),
                  SizedBox(width: 10.w),
                  Expanded(child: _buildFilterBox(endDate)),
                ],
              ),
              SizedBox(height: 10.h),
              _buildFilterBox("Country : $selectedCountry"),

              SizedBox(height: 20.h),

              // Table
              Container(
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
                    // Header Row
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User Name", style: _headerStyle()),
                          ),
                          Expanded(child: Text("Date", style: _headerStyle())),
                          Expanded(
                            child: Text("Amount", style: _headerStyle()),
                          ),
                        ],
                      ),
                    ),

                    // Data Rows
                    ...paymentData.map((payment) {
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
                                payment['user']!,
                                style: _cellStyle(),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                payment['date']!,
                                style: _cellStyle(),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                payment['amount']!,
                                style: _cellStyle().copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // Pagination
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        '$currentPage',
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBox(
    String text, {
    Color bgColor = const Color(0xFFE3F2FD),
    Color textColor = const Color(0xff5E6171),
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: textColor),
          ),
          Icon(Icons.keyboard_arrow_down, color: textColor, size: 18.sp),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade700,
  );

  TextStyle _cellStyle() =>
      TextStyle(fontSize: 12.sp, color: Color(0xff5E6171));
}
