import 'package:catalog_admin/auth/presentation/view/login_view.dart';
import 'package:catalog_admin/auth/presentation/view/splash_view.dart';
import 'package:catalog_admin/home/presentation/view/dashboard_view.dart';
import 'package:catalog_admin/home/presentation/view/main_layout_view.dart';
import 'package:catalog_admin/home/presentation/view/payment_view.dart';
import 'package:catalog_admin/home/presentation/view/profile_view.dart';

import 'package:catalog_admin/home/presentation/view/transactions_view.dart';
import 'package:catalog_admin/home/presentation/view/users_view.dart';
import 'package:catalog_admin/home/presentation/view/subscriptions_view.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashView.routeName:
        return MaterialPageRoute(builder: (_) => SplashView());

      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());

      case MainLayout.routeName:
        return MaterialPageRoute(builder: (_) => MainLayout());

      case DashboardView.routeName:
        return MaterialPageRoute(builder: (_) => DashboardView());

      case PaymentsView.routeName:
        return MaterialPageRoute(builder: (_) => PaymentsView());

      case TransactionsView.routeName:
        return MaterialPageRoute(builder: (_) => TransactionsView());

      case UsersView.routeName:
        return MaterialPageRoute(builder: (_) => UsersView());

      case SubscriptionsView.routeName:
        return MaterialPageRoute(builder: (_) => SubscriptionsView());
      case ProfileView.routeName:
        return MaterialPageRoute(builder: (_) => ProfileView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
