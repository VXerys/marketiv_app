import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    // Auth & Onboarding
    GetPage(
      name: Routes.splash,
      page: () => const Scaffold(body: Center(child: Text('Splash'))),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const Scaffold(body: Center(child: Text('Onboarding'))),
    ),
    GetPage(
      name: Routes.login,
      page: () => const Scaffold(body: Center(child: Text('Login'))),
    ),
    
    // Main Navigation
    GetPage(
      name: Routes.umkmHome,
      page: () => const Scaffold(body: Center(child: Text('UMKM Home'))),
    ),
    GetPage(
      name: Routes.kreatorHome,
      page: () => const Scaffold(body: Center(child: Text('Kreator Home'))),
    ),
  ];
}
