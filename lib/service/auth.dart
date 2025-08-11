import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
final FirebaseAuth _auth = FirebaseAuth.instance;
User? user;
bool isLoading = true;

AuthService() {
_auth.authStateChanges().listen(_onAuthStateChanged);
}

Future<void> _onAuthStateChanged(User? firebaseUser) async {
user = firebaseUser;
isLoading = false;
notifyListeners();
}

Future<void> signInAnonymously() async {
await _auth.signInAnonymously();
}

Future<void> signOut() async {
await _auth.signOut();
}
}