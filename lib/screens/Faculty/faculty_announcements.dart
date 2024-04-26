import 'package:flutter/material.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import '../../common/dio.config.dart'; // Assuming this is the correct import path

class Announcement {
  final String aId;
  final String title;
  final String type;
  final String faculty;
  final String timestamp;
  final String content;
  final List<String> targetClasses;
  final List<String> attachments;

  Announcement({
    required this.aId,
    required this.title,
    required this.faculty,
    required this.type,
    required this.timestamp,
    required this.content,
    required this.attachments,
    required this.targetClasses,
  });
}

class FacultyAnnouncementPage extends StatefulWidget {
  @override
  _FacultyAnnouncementPageState createState() =>
      _FacultyAnnouncementPageState();
}

class _FacultyAnnouncementPageState extends State<FacultyAnnouncementPage> {
  late Future<List<Announcement>> _announcementFuture;

  @override
  void initState() {
    super.initState();
    _announcementFuture = _fetchAnnouncements();
  }

  Future<List<Announcement>> _fetchAnnouncements() async {
    const secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response =
          await dioClient.dio.post('api/faculty/get_announcements/', data: {
        'faculty_id': id,
      });

      final List<Announcement> announcements = [];
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        for (var item in data) {
          print('aId: ${item['aId']}');
          print('title: ${item['title']}');
          print('sender: ${item['sender']}');
          print('type: ${item['type']}');
          print('timestamp: ${item['timestamp']}');
          print('content: ${item['content']}');
          print('attachments: ${item['attachments']}');
          print('targetClasses: ${item['target_classes']}');
          Announcement announcement = Announcement(
            aId: item['a_id'],
            title: item['title'],
            faculty: item['sender'],
            type: item['type'],
            timestamp: item['timestamp'],
            content: item['content'],
            // attachments: [],
            // targetClasses: [],
            attachments: List<String>.from(item['attachments']),
            // attachments: item['attachments'] != null
            // ? List<String>.from(item['attachments'])
            // : [], // Handle null value
            targetClasses: List<String>.from(item['target_classes']),
          );
          announcements.add(announcement);
        }
      }
      return announcements;
    } catch (e) {
      // Handle error
      print('Error fetching announcements: $e');
      throw e; // Rethrow the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        automaticallyImplyLeading: true,
        title: "ANNOUNCEMENTS",
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/facultyAnnouncementClassSelect');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0961F5), // Background color
                        onPrimary: Colors.white, // Text color
                        padding:
                            EdgeInsets.symmetric(vertical: 15), // Larger size
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Make Announcement'),
                          Icon(Icons.arrow_forward, size: 18), // Arrow icon
                        ],
                      ),
                    ),
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
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0,
        onItemSelected: (index) {
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
              announcementContent: announcement.content,
              attachedFiles: announcement.attachments,
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
}

void main() async {
  runApp(MaterialApp(
    home: FacultyAnnouncementPage(),
  ));
}
