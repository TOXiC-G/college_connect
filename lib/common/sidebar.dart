import 'package:flutter/material.dart';
import './navbar.dart';

class CommonSideBar extends StatelessWidget {
  final Widget body;

  CommonSideBar({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi, GEC Student',
          style: TextStyle(fontFamily: 'Jost'),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
              // Handle notification icon tap
            },
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              // Custom header container
              height: 100, // Adjust as per your requirement
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF202244),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Utilities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                          Icons.menu), // Hamburger icon to close the drawer
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Center(
                child: Text(
                  'CGPA Calculator',
                  style: TextStyle(fontSize: 20), // Increase font size
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/cgpaCalculator');
                // Update UI based on drawer item tap
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Add horizontal padding
              child: Divider(
                  // Adjust thickness as needed

                  ),
            ),
            ListTile(
              title: Center(
                child: Text(
                  'Fee Payment',
                  style: TextStyle(fontSize: 20), // Increase font size
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/paymentHome');
                // Update UI based on drawer item tap
              },
            ),
            // Add more ListTiles for additional items
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0, // Set the index according to the current page
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }
}
