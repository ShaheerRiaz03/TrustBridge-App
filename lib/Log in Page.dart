import 'package:course_project/Authentication%20Class.dart';
import 'package:course_project/Bottom%20Navigation%20Bar%20page.dart';
import 'package:course_project/Sign%20Up%20Page.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = false;
  final email =TextEditingController();
  final pass= TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screensize= MediaQuery.of(context).size;
    final screenHeight = screensize.height;
    final screenWidth = screensize.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.15),
                CircleAvatar(
                  radius: 40,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),

                SizedBox(width: 400,
                  child: TextField(controller: email,
                    keyboardType: TextInputType.emailAddress,
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
                  child: TextField(controller: pass,
                    obscureText: _obscureText,
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
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.11),
                InkWell(onTap: ()async {
                    String emailInput = email.text.trim();
                    String passInput = pass.text;

                    String? error = await AuthService().login(emailInput, passInput);
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => bottomnavigation()),
                      );
                    }
                  },
                  splashColor: Colors.grey.shade400,
                  child: Container(height: 60,width: 350,padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text("Log in",style: TextStyle(color: Colors.white,fontSize: 18),)
                      ],
                    ),),
                ),
                SizedBox(height: screenHeight * 0.02),
                InkWell(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Createacc()));
                },
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
              ]
          ),
        ),
      ),
    );
  }
}

class Signin {
  String email;
  String pass;

  Signin({
    required this.email,
    required this.pass,
  });
}