import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Creates a Firebase Auth user & a Firestore user doc with a default role.
  /// By default, users are assigned the 'delivery' role. Change logic as needed.
  Future<UserCredential> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = cred.user?.uid;
    if (uid != null) {
      // Quick role assignment: if email matches a hardcoded admin pattern, make admin.
      final role = email.toLowerCase() == 'admin@rmw.local' ? 'admin' : 'delivery';
      await _fs.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return cred;
  }

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;

  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _fs.collection('users').doc(uid).get();
      if (doc.exists) {
        return (doc.data()?['role'] ?? 'delivery') as String;
      } else {
        return 'delivery';
      }
    } catch (e) {
      // On error, default to delivery
      return 'delivery';
    }
  }
}
