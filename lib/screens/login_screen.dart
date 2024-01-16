// lib/screens/login_screen.dart
import 'package:college_connect/app_routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
                decoration: InputDecoration(
                  hintText: 'Student/Faculty email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              TextField(
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
                  Navigator.pushNamed(context, AppRoutes.home);
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
