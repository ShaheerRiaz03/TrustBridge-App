import 'package:course_project/Change%20password%20page.dart';
import 'package:course_project/LogOut.dart';
import 'package:course_project/Profile%20page%20Settings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: (Column(
            children: [SizedBox(height: 10,),
              Row(
                children: [SizedBox(width: 20,),
                  Text("Settings",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30,)),
                ],
              ),SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 10,),
                  Text("Personal",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,)),
                ],
              ),
          
              buildSettingTile(
                context: context,
                title: "Profile",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                  },
              ),
              buildSettingTile(
                context: context,
                title: "Change Password",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordPage()));
                },
              ),buildSettingTile(
                context: context,
                title: "Shipping Address",
                onTap: () {},
              ),
              SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 10,),
                  Text("Payments & Transactions",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,)),
                ],
              ),
          
              buildSettingTile(
                context: context,
                title: "My Transactions",
                onTap: () {},
              ),
              buildSettingTile(
                context: context,
                title: "Linked Payment Methods",
                onTap: () {},
              ),
              SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 10,),
                  Text("App Settings",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,)),
                ],
              ),
          
              buildSettingTile(
                context: context,
                title: "Notifications",
                onTap: () {},
              ),
              buildSettingTile(
                context: context,
                title: "Appearance ",
                onTap: () {},
              ),
              SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 10,),
                  Text("Support & Feedback",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,)),
                ],
              ),
              buildSettingTile(
                context: context,
                title: "Contact Us",
                onTap: () {},
              ),
              buildSettingTile(
                context: context,
                title: "FAQs",
                onTap: () {},
              ),SizedBox(height: 20,),
              Row(
                children: [SizedBox(width: 10,),
                  Text("Session",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,)),
                ],
              ),
          
              buildSettingTile(
                context: context,
                title: "Log Out",
                onTap: () {
                  LogoutHelper.confirmLogout(context);
                },
              ),
            ],
          )),
        ),
      ),
    );
  }
}


Widget buildSettingTile({
  required BuildContext context,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300, width: 1),
    ),
    child: ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}


