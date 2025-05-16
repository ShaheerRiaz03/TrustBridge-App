import 'package:course_project/Password%20Recover%20Page.dart';
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [SizedBox(height: 30,),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,

              ),

            ],
          ),SizedBox(height: 35,),
          Text("Trust Bridge",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 45,),),
          SizedBox(height: 12,),
          Text("Building Trust,\n One Transaction at a Time.",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w100),)
              ,SizedBox(height: 100,),
          InkWell(onTap: (){},
            splashColor: Colors.grey.shade400,
            child: Container(height: 60,width: 350,padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text("Let's get started",style: TextStyle(color: Colors.white,fontSize: 18),)
                ],
              ),),
          ),
          SizedBox(height: 15,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              SizedBox(width: 15,),
              Ink(decoration: const ShapeDecoration(
                color: Colors.grey,
                shape: CircleBorder(),
              ),
                child: IconButton(onPressed: (){},
                    icon: Icon(Icons.arrow_forward_rounded,
                      )),
              )
            ],
          ),SizedBox(height: 20,)
        ],
      ),
    );

  }
}
