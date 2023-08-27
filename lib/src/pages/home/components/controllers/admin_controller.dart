import 'package:flutter/foundation.dart';

class AdminController with ChangeNotifier {
  final bool _isAdmin = false;

  final bool _isWeb = kIsWeb;

  bool get isWeb => _isWeb;

  bool get isAdmin => _isAdmin;

  // void toggleAdmin() {
  //   _isAdmin = !_isAdmin;
  //   notifyListeners();
  // }
}
