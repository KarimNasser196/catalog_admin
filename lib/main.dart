import 'package:catalog_admin/features/auth/presentation/view/splash_view.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:catalog_admin/core/helper_funcation/app_route.dart';
import 'package:catalog_admin/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await sl<CacheHelper>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Catalog Admin',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Roboto',
          ),
          onGenerateRoute: AppRoute.onGenerateRoute,
          initialRoute: SplashView.routeName,
        );
      },
    );
  }
}
