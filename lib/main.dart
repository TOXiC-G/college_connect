// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:college_connect/providers/college_provider.dart';
import 'package:college_connect/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CollegeProvider()),
        // Add more providers if needed
      ],
      child: MaterialApp(
        title: 'College Connect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontFamily: 'Jost',
            ),
          ),
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.define(),
      ),
    );
  }
}
