import 'package:flutter/material.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey,

          ),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Setup new Password",textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30,),),//gfhgh
            ],
          ),SizedBox(height: 10,),
          Text("Please, setup a new password for \n your account",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w100),),
          SizedBox(height: 10,),
          SizedBox(height: 20,),
          SizedBox(width: 400,
            child: TextField(
              keyboardType: TextInputType.emailAddress,textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'New Password',
                hintStyle: TextStyle(color: Colors.grey),
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
          SizedBox(height: 10,),
          SizedBox(width: 400,
            child: TextField(
              keyboardType: TextInputType.emailAddress,textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Repeat Password',
                hintStyle: TextStyle(color: Colors.grey),
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

          SizedBox(height: 80,),
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
                  Text("Save",style: TextStyle(color: Colors.white,fontSize: 18),)
                ],
              ),),
          ),
          InkWell(onTap: (){
            Navigator.pop(context);
          },
            splashColor: Colors.white24,
            child: Container(height: 60,width: 350,padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
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
      ),  ) ;
  }
}
