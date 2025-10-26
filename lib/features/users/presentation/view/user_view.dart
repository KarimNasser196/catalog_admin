import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:catalog_admin/core/utils/image_assests.dart';
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
                          'Users',
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
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final cubit = context.read<UserCubit>();

        return Column(
          children: [
            GestureDetector(
              onTap: () => _showCountryPicker(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1F1FF),
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

  Future<void> _showCountryPicker(BuildContext context) async {
    final cubit = context.read<UserCubit>();

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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              color: const Color(0xFF5F5FF9).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              user.username,
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
                      if (user.country != null) ...[
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              user.country!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xff5E6171),
                              ),
                            ),
                          ],
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
    final cubit = context.read<UserCubit>();

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
