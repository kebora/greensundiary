import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greensundiary/constants.dart';
import 'package:greensundiary/diary/add_diary_screen.dart';
import 'package:greensundiary/diary/article_screen.dart';
import 'package:greensundiary/diary/chart.dart';
import 'package:greensundiary/diary/view_created_diaries.dart';
import 'package:greensundiary/main.dart';
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
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        Navigator.of(context).pop(this);
        FirebaseAuth.instance.signOut().whenComplete(() {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return MyApp();
          }));
        });
      },
      animType: CoolAlertAnimType.rotate,
    );
  }

  /// end logout dialog

  Widget build(BuildContext context) {
    ///todo: obtain username from email.
    String firstName = user.displayName.toString();
    int firstIndex = firstName.indexOf(' ') ?? 0;
    firstName = firstName.substring(0, firstIndex);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.green,
              ),
              onPressed: () {
                // return showDialog(
                //     context: context,
                //     builder: (_) {
                //       AlertDialog(
                //         title: Text("Account Management"),
                //         content: Text(accountDeactivation),
                //       );
                //     });
              })
        ],
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.green,
          ),
          color: Colors.green,
          onPressed: () {
            _logoutPopUp(context);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton.icon(
          icon: Icon(FontAwesomeIcons.book),
          label: Text("View Diaries"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return ViewCreatedDiaries();
              },
            ));
          },
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to exit'),
          backgroundColor: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Welcome $firstName, below is your green sun chart!",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
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
                    IconButton(
                      icon: Icon(FontAwesomeIcons.newspaper),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ArticleScreen();
                        }));
                      },
                      hoverColor: Colors.green,
                      iconSize: 25,
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.featherAlt),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return AddDiaryScreen();
                        }));
                      },
                      hoverColor: Colors.green,
                      iconSize: 25,
                    ),
                  ],
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(
              "Loading...",
              style: TextStyle(color: Colors.green),
            );
          }

          ///I do this to return the empty circle with some cool lottie animation.
          return Column(
            children: [
              Lottie.asset("assets/images/emptychart.json",
                  width: MediaQuery.of(context).size.width / 2),
              Text(
                "Add a diary to unlock the chart!",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.3,
              ),
            ],
          );
        });
  }
}
