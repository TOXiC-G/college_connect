// lib/screens/login_screen.dart
import 'package:college_connect/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final secureStorage = FlutterSecureStorage();
  Future<void> login(BuildContext context) async {
    const String apiUrl = 'http://192.168.0.104:8000/api/login/';
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
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      // Toggle password visibility
                    },
                  ),
                ),
              ),
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
                    // Implement Guest Sign In logic
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
