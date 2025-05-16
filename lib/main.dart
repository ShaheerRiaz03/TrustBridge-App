import 'package:course_project/New%20Password%20Page.dart';
import 'package:course_project/Password%20Recover%20Page.dart';
import 'package:flutter/material.dart';

import 'Welcome page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NewPasswordPage()
    );

  }
}