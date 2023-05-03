import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greensundiary/authentication/auth_bloc/auth_bloc.dart';
import 'package:greensundiary/diary/add_diary_screen.dart';
import 'package:greensundiary/diary/chart.dart';
import 'package:greensundiary/diary/view_created_diaries.dart';
import 'package:greensundiary/settings/settings_screen.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({required this.user});
  final User user;

  /// Logout dialog
  _logoutPopUp(BuildContext context) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      text: "Do you want to logout?",
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      cancelBtnTextStyle: TextStyle(fontFamily: "Montserrat"),
      confirmBtnTextStyle: TextStyle(fontFamily: "Montserrat"),
      textTextStyle: TextStyle(fontFamily: "Montserrat", fontSize: 18),
      titleTextStyle: TextStyle(
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      confirmBtnColor: Colors.green.shade200,
      onConfirmBtnTap: () => Authentication().handleSignOut(),
      animType: CoolAlertAnimType.rotate,
    );
  }

  /// end logout dialog

  Widget build(BuildContext context) {
    ///todo: obtain username from email.
    String firstName = user.displayName.toString();
    int firstIndex = firstName.indexOf(' ');
    firstName = firstName.substring(0, firstIndex);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.article,
              ),
              onPressed: () {
                Get.to(() => SettingsScreen());
              })
        ],
        backgroundColor: Colors.green.shade200,
        leading: IconButton(
          icon: Icon(
            Icons.logout,
          ),
          onPressed: () {
            _logoutPopUp(context);
          },
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            'Tap back again to exit',
            style: TextStyle(
              fontFamily: "Montserrat",
            ),
          ),
          backgroundColor: Colors.green.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              Text(
                "Welcome $firstName,\nThis is your green sun chart!",
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                ),
                textScaleFactor: 1.5,
              ),
              SizedBox(
                height: 50,
              ),
              ChartAndShare(user),
            ],
          ),
        ),
      ),
    );
  }
}

///Stack2
class ChartAndShare extends StatelessWidget {
  ChartAndShare(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    Stream documentStream = FirebaseFirestore.instance
        .collection('moods')
        .doc(user.uid)
        .snapshots();

    return StreamBuilder(
        stream: documentStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                ///The chart
                Chart(user: user),

                ///check all diaries and share icons.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ViewCreatedDiaries();
                          },
                        ));
                      },
                      icon: Icon(Icons.bookmark),
                      label: Text(
                        "My Diaries",
                        style: TextStyle(fontFamily: "Montserrat"),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return AddDiaryScreen();
                        }));
                      },
                      icon: Icon(Icons.add),
                      label: Text(
                        "Add New",
                        style: TextStyle(fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              "Loading...",
              style: TextStyle(
                color: Colors.green,
                fontFamily: "Montserrat",
              ),
            );
          }

          ///Return the empty circle with some cool lottie animation.
          return Column(
            children: [
              Lottie.asset("assets/images/emptychart.json",
                  width: MediaQuery.of(context).size.width / 2),
              Text(
                "Add a diary to unlock the chart!",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.3,
              ),
            ],
          );
        });
  }
}
