import 'package:course_project/HomePage.dart';
import 'package:course_project/Settings%20Page.dart';
import 'package:flutter/material.dart';

class bottomnavigation extends StatefulWidget {
  const bottomnavigation({super.key});

  @override
  State<bottomnavigation> createState() => _bottomnavigationState();
}

class _bottomnavigationState extends State<bottomnavigation> {
  int selectedindex=0;
  void pressed(int index){
    setState(() {
      selectedindex= index;
    });
  }
  List<dynamic> names=[
    Homepage(),
    Center(child: Text("Recently Viewed")),
    Center(child: Text("Orders")),
    Center(child: Text("Cart")),
    SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:names[selectedindex],
      bottomNavigationBar: BottomNavigationBar(selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.blue,),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,color: Colors.blue,),label: "Recently viewed"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long,color: Colors.blue,),label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,color: Colors.blue,),label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.settings,color: Colors.blue,),label: "Settings")
        ],
        currentIndex: selectedindex,
        onTap: pressed,
      ),
    );
  }
}
