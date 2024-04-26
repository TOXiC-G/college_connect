import 'dart:convert';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeoJsonDemo extends StatefulWidget {
  @override
  _GeoJsonDemoState createState() => _GeoJsonDemoState();
}

class _GeoJsonDemoState extends State<GeoJsonDemo> {
  final String geoJsonString = '''
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": { "name": "Academic" },
          "geometry": { "coordinates": [73.98042628514787, 15.423100339614308], "type": "Point" }
        },
        {
          "type": "Feature",
          "properties": { "name": "Science and Humanities" },
          "geometry": { "coordinates": [73.97936825943782, 15.423050694233552], "type": "Point" }
        },
        {
          "type": "Feature",
          "properties": { "name": "Civil" },
          "geometry": { "coordinates": [73.9794069034611, 15.423505172942328], "type": "Point" }
        },
        {
          "type": "Feature",
          "properties": { "name": "Mechanical" },
          "geometry": { "coordinates": [73.9793817062426, 15.42397931524512], "type": "Point" }
        },
        {
          "type": "Feature",
          "properties": { "name": "Electrical" },
          "geometry": { "coordinates": [73.97875547377956, 15.424468533209136], "type": "Point" }
        },
        {
          "type": "Feature",
          "properties": { "name": "IT" },
          "geometry": { "coordinates": [73.97950737539173, 15.425018252943289], "type": "Point" }
        },
        {
          "type": "Feature",
          "properties": { "name": "mining" },
          "geometry": { "coordinates": [73.97898137645313, 15.42511651883396], "type": "Point" }
        }
      ]
    }
  ''';

  Position? _currentPosition;
  String _currentLocationName = '-';
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position tempPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentPosition = tempPosition;
      });

      print("HELLO MY POSITION IS" + _currentPosition.toString());
      final geoJsonData = jsonDecode(geoJsonString);
      final features = geoJsonData['features'];

      // Iterate through each feature
      for (var feature in features) {
        final coordinates = feature['geometry']['coordinates'];
        final name = feature['properties']['name'];

        // Calculate distance between current position and the point
        final distance = Geolocator.distanceBetween(
          coordinates[1],
          coordinates[0],
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        // If distance is within 10 meters, update the state with the location name
        if (distance <= 10) {
          setState(() {
            _currentLocationName = name;
          });
          break; // Exit loop if a location is found
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'MAP'),
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
                    MarkerLayer(markers: [
                      if (_currentPosition != null)
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                    ])
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
                      'Current Location: ' +
                          _currentLocationName, // Hardcoded text
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
        currentIndex: 3,
        onItemSelected: (index) {},
      ),
    );
  }
}
