import 'package:flutter/material.dart';
import '../../common/navbar.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FacultyNotificationsPage extends StatefulWidget {
  @override
  _FacultyNotificationsPageState createState() =>
      _FacultyNotificationsPageState();
}

class _FacultyNotificationsPageState extends State<FacultyNotificationsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<void> sendNotification(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    // const String apiUrl =
    //     'http://192.168.0.104:8000/api/faculty/sendNotification/';
    const String apiUrl =
        'http://147.185.221.17:22244/api/faculty/sendNotification/'; //Playit
    try {
      final dio = Dio();
      String? token = await secureStorage.read(key: 'accessToken');
      String tokenString = token.toString();
      dio.options.headers['Authorization'] = 'Bearer $tokenString';
      final Response response = await dio.post(
        apiUrl,
        data: {
          'notif_title': titleController.text,
          'notif_body': bodyController.text,
          'notif_data': dataController.text,
        },
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Notification Sent Succesfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        var status = response.statusCode;
        Fluttertoast.showToast(
          msg: 'An error $status occurred. Please try again.',
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
      appBar: AppBar(
        title: const Text(
          'ATTENDANCE',
          style: TextStyle(color: Color(0xFF202244), fontFamily: 'Jost'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Notification Title',
                prefixIcon: Icon(Icons.notification_add_outlined),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                hintText: 'Notification Body',
                prefixIcon: Icon(Icons.notification_add_outlined),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dataController,
              decoration: InputDecoration(
                hintText: 'Notification Data',
                prefixIcon: Icon(Icons.notification_add_outlined),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement your send notification logic here
                // You can use the controllers' text values
                // Example: sendNotification(titleController.text, bodyController.text, dataController.text);
                sendNotification(context);
              },
              child: Text('Send Notification'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0,
        onItemSelected: (index) {
          print('Tapped on item $index');
        },
      ),
    );
  }
}
