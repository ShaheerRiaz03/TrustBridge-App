import 'package:course_project/Compound%20Materials/Compound%20Color.dart';
import 'package:course_project/Log%20in%20Page.dart';
import 'package:course_project/Password%20Recover%20Page.dart';
import 'package:course_project/Sign%20Up%20Page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [SizedBox(height: 30,),
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/Logo.png'),
                backgroundColor: Colors.grey,

              ),

            ],
          ),SizedBox(height: 35,),
          Text("Trust Bridge",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 45,),),
          SizedBox(height: 12,),
          Text("Building Trust,\n One Transaction at a Time.",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300),)
              ,SizedBox(height: 100,),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10), // Match border radius
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Createacc()),
                );
              },
              splashColor: Appcolors.Splash,
              borderRadius: BorderRadius.circular(10),
              child: Ink(
                height: 60,
                width: 350,
                decoration: BoxDecoration(
                  color: Appcolors.theme,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Let's get started",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              SizedBox(width: 15,),
              Ink(decoration: ShapeDecoration(
                color: Appcolors.theme,
                shape: const CircleBorder(),

              ),
                child: IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                },
                    icon: Icon(Icons.arrow_forward_rounded, color: Colors.white,
                      )),
              )
            ],
          ),SizedBox(height: 30,)
        ],
      ),
    );

  }
}
