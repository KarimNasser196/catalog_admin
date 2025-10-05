import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});
  static const String routeName = '/usersView';

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  String selectedCountry = 'Egypt';
  TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> userData = [
    {
      'name': 'Mohamed Mahran',
      'username': '@mahran',
      'phone': '01091992001',
      'email': 'ceo@goo-gnow.com',
    },
    {
      'name': 'Mohamed Mahran',
      'username': '@mahran',
      'phone': '01091992001',
      'email': 'ceo@goo-gnow.com',
    },
    {
      'name': 'Mohamed Mahran',
      'username': '@mahran',
      'phone': '01091992001',
      'email': 'ceo@goo-gnow.com',
    },
    {
      'name': 'Mohamed Mahran',
      'username': '@mahran',
      'phone': '01091992001',
      'email': 'ceo@goo-gnow.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF5F5FF9), // Orange color
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
                        Text(
                          '91,190',
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

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.w),
                  child: Column(
                    children: [
                      // Country Filter
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1F1FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Country: $selectedCountry',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF00796B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFF00796B),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // Search Field
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 2.h,
                        ),
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
                              // fontWeight: FontWeight.w500,
                            ),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: Color(0xff5E6171),
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Users List
                      Expanded(
                        child: ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            final user = userData[index];
                            return Container(
                              padding: EdgeInsets.all(15.w),
                              margin: EdgeInsets.only(bottom: 15.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              user['name']!,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff5E6171),
                                              ),
                                            ),
                                            Text(
                                              user['username']!,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Color(0xff5E6171),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              user['phone']!,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Color(0xff5E6171),
                                              ),
                                            ),
                                            Text(
                                              user['email']!,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Color(0xff5E6171),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Pagination
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.grey,
                            ),
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
                                '2',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
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
}
