import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/google/continue_with_google.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_bloc.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/my_application.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cVal = prefs.getString('myTheme');
  runApp(
    MaterialApp(
      theme: cVal == "dark" ? ThemeData.dark() : ThemeData.light(),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MyAppLogicStarts();
  }
}

class _MyAppLogicStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Authentication.initializeFirebase(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            User user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                return Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(user: user),
                  ),
                );
              });
            }

            ///if no user, authenticate!
            else {
              return BlocProvider(
                create: (content) => MyBloc(),
                child: MyApplication(),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/background/playstore.png",
                      height: 100,
                    ),
                    Text("retrieving data..."),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/background/playstore.png",
                    height: 100,
                  ),
                  Text("A critical error occurred!"),
                ],
              ),
            ),
          );
        });
  }
}
