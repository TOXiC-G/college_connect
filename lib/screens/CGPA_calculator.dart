import 'package:flutter/material.dart';
import 'package:college_connect/common/appbar.dart';
import 'package:college_connect/common/navbar.dart';

class CGPACalculator extends StatefulWidget {
  @override
  _CGPACalculatorState createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  int? currentSemester; // User's current semester
  List<double?> sgpaList = []; // SGPA values for each semester
  List<int> creditsList = [
    16,
    18,
    23,
    24,
    22,
    22,
    17,
    18
  ]; // Credits for each semester

  @override
  void initState() {
    super.initState();
    sgpaList = List<double?>.filled(8, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'CGPA Calculator',
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Enter Your Current Semester',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  currentSemester = value.isEmpty ? null : int.tryParse(value);
                  sgpaList = List<double?>.filled(currentSemester ?? 0, null);
                });
              },
            ),
            SizedBox(height: 20),
            if (currentSemester != null && currentSemester! > 1) ...[
              Text(
                'Enter SGPA for Semesters 1 to ${currentSemester! - 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < currentSemester! - 1; i++)
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      margin: EdgeInsets.only(bottom: 10, right: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Semester ${i + 1} SGPA',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onChanged: (value) {
                          setState(() {
                            sgpaList[i] =
                                value.isEmpty ? null : double.tryParse(value);
                          });
                        },
                      ),
                    ),
                  if (currentSemester! % 2 !=
                      0) // Center the last input box if the total is odd
                    SizedBox(width: MediaQuery.of(context).size.width / 2 - 20),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'CGPA: ${calculateOverallCGPA()?.toStringAsFixed(2) ?? "0.00"}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Percentage: ${calculatePercentage()?.toStringAsFixed(2) ?? "0.00"}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double? calculateOverallCGPA() {
    double totalCredits = 0;
    double totalWeightedGradePoints = 0;

    for (int i = 0; i < sgpaList.length; i++) {
      if (sgpaList[i] != null) {
        totalWeightedGradePoints += sgpaList[i]! * creditsList[i];
        totalCredits += creditsList[i];
      }
    }

    if (totalCredits == 0) {
      // Handle the case where no valid SGPA values are provided
      return null;
    }

    return totalWeightedGradePoints / totalCredits;
  }

  double? calculatePercentage() {
    double totalCredits = 0;
    double totalWeightedPercentage = 0;

    for (int i = 0; i < sgpaList.length; i++) {
      if (sgpaList[i] != null) {
        double percentage = (sgpaList[i]! - 0.75) * 10;
        totalWeightedPercentage += percentage * creditsList[i];
        totalCredits += creditsList[i];
      }
    }

    if (totalCredits == 0) {
      return null;
    }

    return totalWeightedPercentage / totalCredits;
  }
}
