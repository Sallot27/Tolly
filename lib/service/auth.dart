import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuthService with ChangeNotifier {
  String? _userId;
  String? get user => _userId;

  Future<void> signInAnonymously() async {
    _userId = const Uuid().v4();
    notifyListeners();
  }
}
