// lib/core/helper_funcation/app_route.dart

import 'package:catalog_admin/features/auth/presentation/view/login_view.dart';
import 'package:catalog_admin/features/auth/presentation/view/splash_view.dart';
import 'package:catalog_admin/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:catalog_admin/features/payment/presentation/view/payment_view.dart';
import 'package:catalog_admin/features/subscription/presentation/view/subscription_view.dart';
import 'package:catalog_admin/features/transactions/presentation/view/transaction_view.dart';
import 'package:catalog_admin/features/users/presentation/view/user_view.dart';
import 'package:catalog_admin/home/presentation/view/main_layout_view.dart';
import 'package:catalog_admin/features/profile/presentation/view/profile_view.dart';
import 'package:catalog_admin/features/promo/presentation/view/promo_view.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case MainLayout.routeName:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      case DashboardView.routeName:
        return MaterialPageRoute(builder: (_) => const DashboardView());

      case PaymentsView.routeName:
        return MaterialPageRoute(builder: (_) => const PaymentsView());

      case TransactionsView.routeName:
        return MaterialPageRoute(builder: (_) => const TransactionsView());

      case UsersView.routeName:
        return MaterialPageRoute(builder: (_) => const UsersView());

      case SubscriptionsView.routeName:
        return MaterialPageRoute(builder: (_) => const SubscriptionsView());

      case ProfileView.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileView());

      case PromoView.routeName:
        return MaterialPageRoute(builder: (_) => const PromoView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
