import 'package:flutter/material.dart';

void main() {
  runApp(Profile_gp());
}

class Profile_gp extends StatelessWidget {
  static double topContainerHeight = 200, imageHeight = 90;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Page'),
        ),
        body: Container(
          color: Colors.white, // Set the background color of the entire page
          child: Center(
            child: Column(
              children: [
                // First Container: Orange container with background image and circular avatar
                Stack(
                  children: [
                    // Orange Container with background image and circular avatar
                    Column(
                      children: [
                        Row(children: [
                          Expanded(
                            child: Container(
                              height: topContainerHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF7983A),
                                    Color(0xFFEE5035)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Opacity(
                                opacity: 0.2,
                                child: Image.asset(
                                  'assets/images/gp.png', // Replace with your PNG file path
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          )
                        ]),
                        Container(
                          height: 100,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10.0 + imageHeight / 2,
                            ),
                            child: Column(
                              children: [
                                Text("Aryan Ghorpade"),
                                Text("PC-114523"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: topContainerHeight - imageHeight / 2,
                      left: MediaQuery.of(context).size.width * 0.5 -
                          imageHeight / 2,
                      child: Container(
                        height: imageHeight,
                        width: imageHeight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Third Container: Scrollable list of items
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          customListItem(
                              'PAST BEAT VISITS', Icons.map_outlined),
                          Divider(),
                          customListItem('PAST PERSON VISITS',
                              Icons.person_outline_rounded),
                          Divider(),
                          customListItem(
                              'PAST COURT ORDERS', Icons.gavel_outlined),
                          Divider(),
                          customListItem(
                              'VIEW DAILY LOGS', Icons.remove_red_eye_outlined),
                          Divider(),
                          customListItem(
                              'EDIT PROFILE', Icons.mode_edit_outlined),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Fourth Container: White container at the bottom
                Container(
                  height: 100,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: customListItem(
                                  "LOGOUT", Icons.logout_outlined)
                              // child: OutlinedButton(
                              //   onPressed: () => {},
                              //   child: Text("LOGOUT"),
                              //   style: OutlinedButton.styleFrom(
                              //     side: BorderSide(
                              //         color: Colors.black), // Border color
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(
                              //             10.0)), // Border radius
                              //   ),
                              // ),
                              ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // Align children at the end
                        children: [
                          OutlinedButton(
                            onPressed: () => {},
                            child: Text("DAILY LOG +"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customListItem(String text, IconData iconData) {
  LinearGradient gradient = LinearGradient(
    colors: [Color(0xFFF7983A), Color(0xFFEE5035)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Determine the color of the border based on the text color
  Color borderColor = text == 'orange' ? Colors.orange : Colors.transparent;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return gradient.createShader(bounds);
                },
                child: Icon(iconData,
                    color: Colors.white), // Apply gradient color to the icon
              ),
              SizedBox(width: 10), // Add spacing between icon and text
              Text(text), // Text
            ],
          ),
          Icon(Icons.arrow_forward), // Right-aligned arrow icon
        ],
      ),
    ),
  );
}
