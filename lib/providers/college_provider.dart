// lib/providers/college_provider.dart
import 'package:flutter/foundation.dart';

class CollegeProvider extends ChangeNotifier {
  String? _currentUserType;

  String? get currentUserType => _currentUserType;

  void setCurrentUserType(String userType) {
    _currentUserType = userType;
    notifyListeners();
  }

  // You can add more methods or properties specific to your app's needs
}
