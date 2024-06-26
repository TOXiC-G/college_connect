import 'package:flutter/material.dart';
import '../common/navbar.dart';
import '../common/appbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../common/dio.config.dart';

class Announcement {
  final String aId;
  final String title;
  final String description;
  final String timestamp;
  final String faculty;
  final List<String> targetClasses;
  final List<String> targetStudents;
  final List<String> attachment;
  final String type;

  Announcement({
    required this.aId,
    required this.title,
    required this.faculty,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.attachment,
    required this.targetClasses,
    required this.targetStudents,
  });
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Announcement>> _announcementFuture;
  @override
  void initState() {
    super.initState();
    _announcementFuture = getNotifications();
  }

  Future<List<Announcement>> getNotifications() async {
    const secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(
        key: 'id'); // Get the user ID from secure storage

    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final List<Announcement> announcements = [];
      final Response response = await dioClient.dio.post(
        'api/student/get_announcements',
        data: {
          'student_id': id,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        final List<dynamic> data = response.data;
        // Successful fetch
        for (var item in data) {
          Announcement announcement = Announcement(
            aId: item['a_id'].toString(),
            title: item['title'],
            description: item['description'],
            timestamp: item['timestamp'],
            faculty: item['faculty'],
            targetClasses: List<String>.from(
                item['courses'].map((course) => course.toString())),
            targetStudents: List<String>.from(
                item['students'].map((student) => student.toString())),
            attachment: item['attachments'] ?? [],
            type: item['type'],
          );
          announcements.add(announcement);
        }

        print(announcements);

        return announcements;
      } else {
        // Failed fetch
        Fluttertoast.showToast(
          msg: 'Failed to fetch notifications',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return [];
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
      return [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Notifications',
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Announcement>>(
        future: _announcementFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                        height:
                            16), // Add some spacing between the button and announcement cards
                    if (snapshot.hasData) // Check if data is available
                      ..._buildAnnouncementCards(snapshot.data),
                  ],
                ),
              ),
            );
          }
        },
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(20.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         // Search bar
      //         Container(
      //           padding: EdgeInsets.all(8),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             borderRadius: BorderRadius.circular(10),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.grey.withOpacity(0.3),
      //                 spreadRadius: 2,
      //                 blurRadius: 3,
      //                 offset: Offset(0, 3),
      //               ),
      //             ],
      //           ),
      //           child: Row(
      //             children: [
      //               Icon(Icons.search),
      //               SizedBox(width: 8),
      //               Text(
      //                 'Search for...',
      //                 style: TextStyle(fontFamily: 'Jost'),
      //               ),
      //             ],
      //           ),
      //         ),
      //         SizedBox(height: 20),

      //         // Payments Due
      //         Text(
      //           'PAYMENTS DUE',
      //           style: TextStyle(
      //               fontFamily: 'Jost',
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold),
      //         ),
      //         _buildPaymentDueContainer(
      //           'EXAM REGISTRATION (SEM VIII)',
      //           '09-01-2024',
      //           '₹3500',
      //           '#FFE5E5',
      //           '#7E1616',
      //         ),
      //         _buildPaymentDueContainer(
      //           'SEMESTER FEES (SEM VIII)',
      //           '09-01-2024',
      //           '₹30000',
      //           '#FFE5E5',
      //           '#7E1616',
      //         ),
      //         Divider(),

      //         // Notifications
      //         Text(
      //           'NOTIFICATIONS',
      //           style: TextStyle(
      //               fontFamily: 'Jost',
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold),
      //         ),

      //         // _buildNotificationContainer(
      //         //   'STUDENT REGISTRATION FOR CURRENT SEMESTER',
      //         //   'GEC ADMINISTRATION',
      //         //   Colors.yellow,
      //         // ),
      //         // _buildNotificationContainer(
      //         //   'IT 1 - TIME TABLE',
      //         //   'IT DEPARTMENT',
      //         //   Colors.yellow,
      //         // ),
      //         // _buildNotificationContainer(
      //         //   'IT 1 - CLOUD COMPUTING - ASSIGNMENT 1',
      //         //   'BIPIN NAIK',
      //         //   Colors.black,
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0,
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }

  List<Widget> _buildAnnouncementCards(List<Announcement>? announcements) {
    if (announcements == null || announcements.isEmpty) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('No announcements available.')],
        )
      ];
    }
    return announcements
        .map((announcement) => _buildClassCard(
              title: announcement.title,
              faculty: announcement.faculty,
              time: announcement.timestamp,
              buttonLabel: 'View Announcement',
              buttonColor: Colors.blue,
              buttonStrokeColor: Colors.blueAccent,
              announcementContent: announcement.description,
              attachedFiles: announcement.attachment,
            ))
        .toList();
  }

  Widget _buildClassCard({
    required String title,
    required String faculty,
    required String time,
    required String buttonLabel,
    required Color buttonColor,
    required Color buttonStrokeColor,
    required String announcementContent,
    required List<String> attachedFiles,
  }) {
    return Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: buttonStrokeColor, width: 2),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(time),
        childrenPadding: EdgeInsets.all(16.0),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            announcementContent,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          if (attachedFiles.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attached Files:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: attachedFiles
                      .map((file) => InkWell(
                            onTap: () {
                              // Handle file download
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                file,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentDueContainer(
    String paymentName,
    String dueDate,
    String amountDue,
    String bgColor,
    String strokeColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(int.parse(bgColor.replaceAll("#", "0xFF"))),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(int.parse(strokeColor.replaceAll("#", "0xFF"))),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttribute('PAYMENT NAME', paymentName),
          _buildAttribute('DUE ON', dueDate),
          _buildAttribute('AMOUNT DUE', amountDue),
        ],
      ),
    );
  }

  Widget _buildNotificationContainer(
    String title,
    String uploadedBy,
    Color strokeColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: strokeColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttribute('TITLE', title),
          _buildAttribute('UPLOADED BY', uploadedBy),
        ],
      ),
    );
  }

  Widget _buildAttribute(String attributeName, String attributeValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$attributeName:',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8), // Add some spacing between attribute name and value
        Flexible(
          child: Text(
            attributeValue,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
  ));
}
