import 'package:course_project/Authentication%20Class.dart';
import 'package:course_project/Bottom%20Navigation%20Bar%20page.dart';
import 'package:course_project/Compound%20Materials/Compound%20Color.dart';
import 'package:course_project/Log%20in%20Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Createacc extends StatefulWidget {
  const Createacc({super.key});

  @override
  State<Createacc> createState() => _CreateaccState();
}

class _CreateaccState extends State<Createacc> {
  bool _ObscureText = false;
  bool _ObsecureText1 = false;
  final email = TextEditingController();
  final pass = TextEditingController();
  final name = TextEditingController();
  final confirmpass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.05,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.15),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(width: 400,
                    child: TextField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(width: 400,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.all(20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(width: 400,
                    child: TextField(
                      controller: pass,
                      obscureText: _ObscureText,
                      decoration: InputDecoration(
                        labelText: "Passward",
                        hintText: "Enter your passward",
                        contentPadding: EdgeInsets.all(20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ObscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _ObscureText = !_ObscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(width: 400,
                    child: TextField(
                      controller: confirmpass,
                      obscureText: _ObsecureText1,
                      decoration: InputDecoration(
                        labelText: "Confirm Passward",
                        hintText: "Confrim your passward",
                        contentPadding: EdgeInsets.all(20),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ObsecureText1? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _ObsecureText1 = !_ObsecureText1;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                      
                  SizedBox(height: screenHeight * 0.08),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () async {
                        if (pass.text != confirmpass.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Passwords do not match")),
                          );
                          return;
                        }

                        final username = name.text.trim();
                        final dbRef = FirebaseDatabase.instance.ref().child("users");

                        final snapshot = await dbRef.orderByChild("username").equalTo(username).once();

                        if (snapshot.snapshot.exists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Username already exists")),
                          );
                          return;
                        }

                        String? error = await AuthService().signUp(name.text, email.text, pass.text);

                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        } else {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            final userRef = dbRef.child(user.uid);
                            await userRef.set({
                              "uid": user.uid,
                              "name": name,
                              "email": email.text.trim(),
                              "password": pass.text.trim(),
                            });
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        }
                      },

                      splashColor: Appcolors.Splash,
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        height: 60,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  InkWell(onTap: (){
                    Navigator.pop(context);},
                    splashColor: Colors.grey.shade400,
                    child: Container(height: 60,width: 350,padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text("Cancel",style: TextStyle(color: Colors.black,fontSize: 18),)
                        ],
                      ),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Account {
  String name;
  String email;
  String pass;
  String confirmpass;

  Account({
    required this.email,
    required this.pass,
    required this.name,
    required this.confirmpass,
  });
}

