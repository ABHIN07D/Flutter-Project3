import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; 
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; 
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
