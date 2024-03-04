// lib/screens/login_screen.dart
import 'package:college_connect/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../api/firebase_api.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);
  final secureStorage = FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    const String apiUrl = 'http://192.168.0.105:8000/api/login/'; // Local
    // const String apiUrl = 'http://147.185.221.17:22244/api/login/'; //Playit
    print("WORKING");
    try {
      final dio = Dio();
      final Response response = await dio.post(
        apiUrl,
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        // Parse the response and store the token, role, and user attributes
        var accessToken = response.data['access'];
        var refreshToken = response.data['refresh'];
        var role = response.data['role'];
        var user = response.data['user'];
        var id = response.data['id'].toString();
        await secureStorage.write(key: 'accessToken', value: accessToken);
        await secureStorage.write(key: 'refreshToken', value: refreshToken);
        await secureStorage.write(key: 'role', value: role);
        await secureStorage.write(key: 'user', value: user);
        await secureStorage.write(key: 'id', value: id);
        WidgetsFlutterBinding.ensureInitialized();
        Platform.isAndroid
            ? await Firebase.initializeApp(
                options: const FirebaseOptions(
                    apiKey: 'AIzaSyCsC3adhpsZLqJ9TWOkpcKqdjN0cGMyFf4',
                    appId: '1:427827354834:android:42c46a5017a72d0217210b',
                    messagingSenderId: '427827354834',
                    projectId: 'collegeconnect-c4527'))
            : await Firebase.initializeApp();
        await FirebaseApi().initNotifications();
        // Navigate to the next page
        if (role == 'student') Navigator.pushNamed(context, AppRoutes.home);

        if (role == 'faculty')
          Navigator.pushNamed(context, AppRoutes.facultyHome);
      } else {
        // Failed login
        Fluttertoast.showToast(
          msg: 'Invalid credentials',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // Handle network or other errors
      print(error.toString());
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Text(
                'College Connect'.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202244), // Lighter font color
                ),
                textAlign: TextAlign.center, // Center text
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/gec.png', // Replace with your PNG file path
                height: 150,
                width: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Sign In'.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202244), // Lighter font color
                  // Uppercase
                ),
                textAlign: TextAlign.center, // Center text
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Student/Faculty email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              PasswordField(passwordController: passwordController),
              // TextField(
              //   controller: passwordController,
              //   obscureText: obscureTextNotifier.value,
              //   decoration: InputDecoration(
              //     hintText: 'Password',
              //     prefixIcon: Icon(Icons.lock),
              //     suffixIcon: IconButton(
              //       icon: Icon(Icons.visibility),
              //       onPressed: () {
              //         obscureTextNotifier.value = !obscureTextNotifier.value;
              //         // Toggle password visibility
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Text('Remember me'),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      // Navigate to forgot password screen
                    },
                    child: Text('Forgot password?'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement Sign In logic
                  print("YUH");
                  login(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF0961F5), // Background color
                  onPrimary: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(vertical: 15), // Larger size
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign In'),
                    Icon(Icons.arrow_forward, size: 18), // Arrow icon
                  ],
                ),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 70,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.profile_gp);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF122966)), // Border color
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Guest Sign In'),
                      Icon(Icons.arrow_forward, size: 18), // Arrow icon
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Navigate to trouble signing in screen
                },
                child: Text(
                  'Having trouble signing in?',
                  textAlign: TextAlign.center, // Center text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;

  PasswordField({required this.passwordController});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  // TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: _isPasswordVisible
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
