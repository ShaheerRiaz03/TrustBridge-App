import 'package:course_project/BuyerHomePage.dart';
import 'package:course_project/Chat%20Page.dart';
import 'package:course_project/Contact%20list%20chat.dart';
import 'package:course_project/Link%20Submission%20Page.dart';
import 'package:course_project/SellerHomePage.dart';
import 'package:course_project/Settings%20Page.dart';
import 'package:course_project/User%20Toggle%20class.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class bottomnavigation extends StatefulWidget {
  const bottomnavigation({super.key});

  @override
  State<bottomnavigation> createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final users = _auth.currentUser;
    return users?.uid;
  }  int selectedindex = 0;
  bool isBuyer = true; // <-- Add this line

  void pressed(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  void toggleProfile(bool value) {
    setState(() {
      isBuyer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> names = [
      isBuyer
          ? Buyerhomepage(isBuyer: isBuyer, onToggle: toggleProfile)
          : SellerHomePage(isBuyer: isBuyer, onToggle: toggleProfile),
      const Center(child: Text("Recently Viewed")),
      ProductLinkSubmissionPage(),
      ChatContactsScreen(currentUserId: getCurrentUserId() ?? ""  ,),
      SettingsPage()
    ];

    return Scaffold(

      body: names[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.blue), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Colors.blue), label: "Recently viewed"),
          BottomNavigationBarItem(icon: Icon(Icons.link_rounded, color: Colors.blue), label: "Link Submit"),
          BottomNavigationBarItem(icon: Icon(Icons.chat, color: Colors.blue), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.settings, color: Colors.blue), label: "Settings"),
        ],
        currentIndex: selectedindex,
        onTap: pressed,
      ),
    );
  }
}

