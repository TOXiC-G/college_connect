// Import necessary packages
import 'package:flutter/material.dart';
// import '../common/navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../common/navbar.dart';
import '../common/appbar.dart';
import '../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Profile {
  final String name;
  final String email;
  final String stream;
  final String profilePic;

  final String? designation;
  // final String? phone;

  final String? roll;
  final String? year;
  final String? batch;
  final String? prNo;

  Profile({
    required this.name,
    required this.email,
    required this.stream,
    required this.profilePic,
    this.designation,
    // this.phone,
    this.roll,
    this.year,
    this.batch,
    this.prNo,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'].toString(),
      email: json['email'].toString(),
      stream: json['stream'].toString(),
      profilePic: json['profile_pic'].toString(),
      designation: json['designation'].toString(),
      // phone: json['phone'],
      roll: json['roll'].toString(),
      year: json['year'].toString(),
      batch: json['batch'].toString(),
      prNo: json['pr_no'].toString(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _profile = {};
  String? _role = "";

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  final secureStorage = FlutterSecureStorage();
  void _logout(BuildContext context) async {
    await secureStorage.deleteAll();
    Navigator.pushNamed(context, '/'); // Replace with your login screen route
  }

  Future<void> fetchProfile() async {
    final secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    String? role = await secureStorage.read(key: 'role');
    if (role != null) {
      setState(() => _role = role.toUpperCase());
    }
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/profile/',
        data: {
          'id': id,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _profile = response.data;
        });
        print(_profile);
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch courses',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
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
      appBar: CommonAppBar(
        title: 'PROFILE',
        // Remove the back arrow
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular profile avatar acting as an upload button
              GestureDetector(
                onTap: () {
                  // Handle avatar upload button tap
                  // You can add image upload logic here
                },
                child: _profile.isNotEmpty
                    ? CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Colors.blue, // You can customize the color
                        backgroundImage: NetworkImage(_profile['profile_pic']),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Colors.blue, // You can customize the color
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(height: 10),

              // Text 'STUDENT ACCOUNT DETAILS'
              Text(
                '$_role ACCOUNT DETAILS',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),

              // Container with student details
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey), // Add border
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: _profile.isNotEmpty
                      ? _profile.keys
                          .where((key) => key != 'profile_pic')
                          .map((key) {
                          return Column(
                            children: [
                              _buildAttribute(
                                  key.substring(0, 1).toUpperCase() +
                                      key.substring(1),
                                  _profile[key].toString()),
                              _buildDivider(),
                            ],
                          );
                        }).toList()
                      : [],
                ),
              ),
              SizedBox(height: 20),

              // Divider
              Divider(height: 1, color: Colors.grey.withOpacity(0.7)),
              SizedBox(height: 20),

              // Logout and Change Password buttons
              _buildButton('LOGOUT', Colors.blue, context),
              SizedBox(height: 10),
              _buildButton('CHANGE PASSWORD', Colors.red, context),
              SizedBox(height: 20),

              // Divider
              Divider(height: 1, color: Colors.grey.withOpacity(0.7)),
              SizedBox(height: 20),

              // Custom navbar element with index value 4
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 4,
        onItemSelected: (index) {
          // Handle navigation based on index
        },
      ),
    );
  }

  Widget _buildAttribute(String attributeName, String attributeValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$attributeName :',
          style: TextStyle(fontFamily: 'Jost'),
        ),
        Text(
          attributeValue,
          style: TextStyle(fontFamily: 'Jost'),
        ),
      ],
    );
    return Container();
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.withOpacity(0.7));
  }

  Widget _buildButton(String text, Color color, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle button tap
        if (text == 'LOGOUT') {
          _logout(context);
        } else if (text == 'CHANGE PASSWORD') {
          // Handle change password
        }
      },
      style: ElevatedButton.styleFrom(
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        side: BorderSide(color: color, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Jost', color: color),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
