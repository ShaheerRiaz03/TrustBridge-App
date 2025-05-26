import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<String?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.child("users").child(userCred.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCred.user!.uid,
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCred.user!.uid;
      DataSnapshot snapshot = await _db.child("users").child(uid).get();
      String name = snapshot
          .child("name")
          .value
          .toString();

      print("Welcome, $name");

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
