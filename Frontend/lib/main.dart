import 'package:flutter/material.dart';
import 'package:point_sale/features/transactions/providers/transaction_provider.dart';
import 'package:point_sale/features/orders/providers/order_provider.dart';
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'package:point_sale/app/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/cart/providers/cart_provider.dart';
import 'package:point_sale/features/analytics/providers/analytics_provider.dart';
import 'package:point_sale/features/auth/data/auth_service.dart';
import 'package:point_sale/core/services/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.restoreSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductInventoryProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Point Sale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B8D0),
        ),
        useMaterial3: true,
      ),

      onGenerateRoute: (settings) {
        final route = settings.name ?? AppRoutes.home;

        final isSigninRoute = route == AppRoutes.signin ||
            route == AppRoutes.signup ||
            route == AppRoutes.forgetPassword;

        final isLoggedIn = UserSession.instance.user != null;

        // Not logged in → Sign In
        if (!isLoggedIn && !isSigninRoute) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: AppRoutes.signin),
            builder: (_) => AppRoutes.routes[AppRoutes.signin]!(context),
          );
        }

        // Already logged in → don't allow going back to Sign In
        if (isLoggedIn && route == AppRoutes.signin) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: AppRoutes.home),
            builder: (_) => AppRoutes.routes[AppRoutes.home]!(context),
          );
        }

        final builder = AppRoutes.routes[route];

        if (builder != null) {
          return MaterialPageRoute(
            settings: settings,
            builder: builder,
          );
        }

        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (_) => AppRoutes.routes[AppRoutes.home]!(context),
        );
      },
    );
  }
}