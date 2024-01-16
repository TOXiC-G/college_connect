import 'package:flutter/material.dart';
import '../common/navbar.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOTIFICATIONS',
          style: TextStyle(color: Color(0xFF202244), fontFamily: 'Jost'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search bar
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text(
                      'Search for...',
                      style: TextStyle(fontFamily: 'Jost'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Payments Due
              Text(
                'PAYMENTS DUE',
                style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              _buildPaymentDueContainer(
                'EXAM REGISTRATION (SEM VIII)',
                '09-01-2024',
                '₹3500',
                '#FFE5E5',
                '#7E1616',
              ),
              _buildPaymentDueContainer(
                'SEMESTER FEES (SEM VIII)',
                '09-01-2024',
                '₹30000',
                '#FFE5E5',
                '#7E1616',
              ),
              Divider(),

              // Notifications
              Text(
                'NOTIFICATIONS',
                style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              _buildNotificationContainer(
                'STUDENT REGISTRATION FOR CURRENT SEMESTER',
                'GEC ADMINISTRATION',
                Colors.yellow,
              ),
              _buildNotificationContainer(
                'IT 1 - TIME TABLE',
                'IT DEPARTMENT',
                Colors.yellow,
              ),
              _buildNotificationContainer(
                'IT 1 - CLOUD COMPUTING - ASSIGNMENT 1',
                'BIPIN NAIK',
                Colors.black,
              ),
            ],
          ),
        ),
      ),
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
