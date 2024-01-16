// Import necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Updated package for handling latitude and longitude
import '../common/navbar.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(color: Color(0xFF202244), fontFamily: 'Jost'),
        ),
        // Remove the back arrow
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Box with a navigatable map
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey), // Add border
                ),
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(15.423095122914946, 73.97985675045817),
                    zoom: 17.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Box at the bottom with text and button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey), // Add border
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Current Location: IT Dept', // Hardcoded text
                      style: TextStyle(fontFamily: 'Jost'),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey), // Horizontal divider
                  ElevatedButton(
                    onPressed: () {
                      // Handle VIEW DEPT MAP button tap
                      // Add navigation logic or any other action
                    },
                    child: Text('VIEW DEPT MAP'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 3, // Set the index according to the current page
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapPage(),
  ));
}
