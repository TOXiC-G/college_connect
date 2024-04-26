import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import '../../common/dio.config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class MakeAnnouncementPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  late String selectedType = '';
  // final TextEditingController  = TextEditingController();

  Future<void> _makeAnnoucement(List<String> selectedCourseIds) async {
    const secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();

      final Response response =
          await dioClient.dio.post('api/faculty/make_announcement/', data: {
        'sender': id,
        'title': titleController.text,
        'content': contentController.text,
        'a_type': selectedType,
        'target_classes': selectedCourseIds,
      });

      if (response.statusCode == 200) {
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
    final List<String> selectedCourseIds =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Make Announcement',
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Announcement Title',
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Announcement Type',
              ),
              items: [
                DropdownMenuItem(
                  value: 'Assignment',
                  child: Text('Assignment'),
                ),
                DropdownMenuItem(
                  value: 'IT',
                  child: Text('IT'),
                ),
                DropdownMenuItem(
                  value: 'Other',
                  child: Text('Other'),
                ),
              ],
              onChanged: (String? value) {
                selectedType = value!;
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Announcement Content',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement announcement submission logic
                Fluttertoast.showToast(
                  msg: 'Announcement submitted',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                _makeAnnoucement(selectedCourseIds);
                // Navigator.pop(context); // Go back to previous page
              },
              child: Text('Submit Announcement'),
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

void main() {
  runApp(MaterialApp(
    home: MakeAnnouncementPage(), // Pass your selected course IDs here
  ));
}
