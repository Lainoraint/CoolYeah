import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static const String successMessage = 'Success';
  static const String userNotFoundMessage = 'Email tidak ditemukan';
  static const String wrongPasswordMessage =
      'Password yang anda masukkan salah';
  static const String emailInUseMessage =
      'Email telah digunakan, Silahkan coba email lainnya';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user role and password in Firestore (default 'user' role)
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': 'user', // Default role, change to 'admin' if needed
        'password': password, // Storing plaintext password (not recommended)
      });

      return successMessage;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return emailInUseMessage;
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      // Login dengan Firebase Authentication
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil UID pengguna
      final String uid = userCredential.user!.uid;

      // Ambil role pengguna dari Firestore
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc['role']; // Kembalikan role dari Firestore
      } else {
        return null;
      }
    } catch (e) {
      return null; // Kembalikan null jika terjadi error
    }
  }
}
