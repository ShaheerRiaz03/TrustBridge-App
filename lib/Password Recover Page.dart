import 'package:flutter/material.dart';

class PasswordRecoverPage extends StatefulWidget {
  const PasswordRecoverPage({super.key});

  @override
  State<PasswordRecoverPage> createState() => _PasswordRecoverPageState();
}

class _PasswordRecoverPageState extends State<PasswordRecoverPage> {
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
              Text("Password Recovery",textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30,),),
            ],
          ),SizedBox(height: 10,),
          Text("Enter your email to \n get password recovery code",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w100),),
          SizedBox(height: 20,),
          SizedBox(width: 400,
            child: TextField(
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
          SizedBox(height: 120,),
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
                  Text("Send",style: TextStyle(color: Colors.white,fontSize: 18),)
                ],
              ),),
          ),
          InkWell(onTap: (){},
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
