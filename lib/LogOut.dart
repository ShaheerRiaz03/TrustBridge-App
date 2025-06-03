// logout_helper.dart
import 'package:course_project/Log%20in%20Page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LogoutHelper {
  static Future<void> logout(BuildContext context) async {
    final dbref = FirebaseDatabase.instance.ref().child("logout");
    final user = FirebaseAuth.instance.currentUser;

    await dbref.push().set({
      "uid": user?.uid,
      "timestamp": DateTime.now().toIso8601String(),
    });

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }

  static void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              logout(context);
            },
            child: const Text("Logout",style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );
  }
}
