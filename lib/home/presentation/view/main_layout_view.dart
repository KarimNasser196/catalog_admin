import 'package:catalog_admin/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:catalog_admin/home/presentation/view/widgets/app_bottom_navigator_bar_widget.dart';
import 'package:catalog_admin/features/profile/presentation/view/profile_view.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  static const routeName = '/mainlayout';

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [DashboardView(), ProfileView()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: AppBottomNavigatorBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) => _onTap(index),
      ),
    );
  }
}
