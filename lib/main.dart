import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/google/continue_with_google.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_bloc.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
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
            return _Message(
              myText: "retrieving data...",
            );
          }
          return _Message(
            myText: "working on your application...",
          );
        });
  }
}

class _Message extends StatelessWidget {
  const _Message({Key key, this.myText}) : super(key: key);
  final String myText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/background/playstore.png",
              height: 100,
            ),
            Text(myText),
          ],
        ),
      ),
    );
  }
}
