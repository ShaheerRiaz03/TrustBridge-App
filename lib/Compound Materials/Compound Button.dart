import 'package:flutter/material.dart';

class custombutton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;

  const custombutton({
    super.key,
    required this.text,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      splashColor: Colors.grey.shade400,
      child: Container(
        height: 60,
        width: 350,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
