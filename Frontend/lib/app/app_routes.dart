import 'package:flutter/material.dart';
import 'package:point_sale/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:point_sale/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:point_sale/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:point_sale/features/cart/presentation/screens/checkout_screen.dart';
import 'package:point_sale/features/home/presentation/screens/home_screen.dart';

import 'package:point_sale/features/about/presentation/screens/about_us_screen.dart';
import 'package:point_sale/features/stock/presentation/screens/stock_management.dart';
import 'package:point_sale/features/products/presentation/screens/products_screen.dart';
import 'package:point_sale/features/transactions/presentation/screens/transactions_view.dart';
import 'package:point_sale/features/orders/presentation/screens/orders_screen.dart';
import 'package:point_sale/features/analytics/presentation/screens/analytics_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String checkout = '/checkout';
  static const String logout = '/logout';
  static const String forgetPassword = '/forget-password';
  static const String stockmanagement = '/stock';
  static const String about = '/about';
  static const String products = '/products';
  static const String transactions = '/transactions';
  static const String orders = '/orders';
  static const String analytics = '/analytics';

  static Map<String, WidgetBuilder> routes = {
    home: (context ) => const HomeScreen(),
    signin: (context) => const SignInScreen(),
    signup: (context) => const SignUpScreen(),
    forgetPassword: (context) => const ForgotPasswordScreen(),
    checkout: (context) => const CheckoutScreen(),
    stockmanagement: (context) => const StockManagementView(),
    about: (context) => const AboutUsScreen(),
    products: (context) => const ProductsScreen(),
    transactions: (context) => const TransactionsView(),
    orders: (context) => const OrdersScreen(),
    analytics: (context) => const AnalyticsScreen(),
  };
}
