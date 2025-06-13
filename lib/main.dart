import 'package:course_project/Add%20Product%20Page.dart';
import 'package:course_project/Bottom%20Navigation%20Bar%20page.dart';
import 'package:course_project/Link%20Submission%20Page.dart';
import 'package:course_project/Seller%20Add%20Services.dart';
import 'package:course_project/Welcome%20page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load login state
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? bottomnavigation() : WelcomePage(),
    );
  }
}
