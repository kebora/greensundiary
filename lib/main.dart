import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:greensundiary/authentication/auth_bloc/auth_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_bloc.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
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
        future: Authentication.initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              //
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Future.microtask(() => Get.off(() => HomeScreen(user: user)));
              });
              // Future.microtask(() => Get.off(HomeScreen(user: user)));
            }

            ///if no user, authenticate!
            else {
              return BlocProvider(
                create: (content) => SwitchCubit(),
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
            myText: "wait a little...",
          );
        });
  }
}

class _Message extends StatelessWidget {
  const _Message({Key? key, required this.myText}) : super(key: key);
  final String myText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              myText,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
