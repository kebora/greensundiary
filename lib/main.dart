import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greensundiary/authentication/google/authenticate_account.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/logo/smiley.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      // theme: ThemeData.dark(),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong!");
        }
        // Once complete, show the application based on whether user is available
        if (snapshot.connectionState == ConnectionState.done) {
          User user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return HomeScreen(
              user: user,
            );
          } else {
            return AuthenticateAccount();
          }
        }
        return Smiley();
      },
    );
  }
}
