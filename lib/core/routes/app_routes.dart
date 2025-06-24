import 'package:flutter/material.dart';
import 'package:handycraft_app/main.dart';
import 'package:handycraft_app/screens/product/product_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String product = '/product';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => MyApp());
      case product:
        return MaterialPageRoute(builder: (_) => const ProductScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
