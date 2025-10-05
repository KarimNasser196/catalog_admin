import 'package:catalog_admin/core/utils/image_assests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavigatorBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigatorBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF3B5BA9),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(ImageAssets.homeIcon, width: 26.w),
          label: 'home',
        ),

        BottomNavigationBarItem(
          icon: Image.asset(
            ImageAssets.contactIcon,
            width: 26.w,
            color: Color(0xff8696BB), //
          ),
          label: 'profile',
        ),
      ],
    );
  }
}
