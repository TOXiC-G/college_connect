// lib/app_routes.dart
import 'package:flutter/material.dart';
import 'package:college_connect/screens/login_screen.dart';

class AppRoutes {
  static const String login = '/';

  static Map<String, WidgetBuilder> define() {
    return {
      login: (context) => LoginScreen()
      // Add more routes as needed
    };
  }
}
