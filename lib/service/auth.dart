import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in a user anonymously.
  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      debugPrint('Error signing in: ${e.message}');
    }
  }

  // Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
