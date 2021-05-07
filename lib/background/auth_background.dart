import 'package:flutter/material.dart';

//return background in the stack
class AuthBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Image.asset(
        "assets/images/background/auth_pic.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
