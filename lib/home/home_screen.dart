import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greensundiary/authentication/google/authenticate_account.dart';
import 'package:greensundiary/diary/add_diary_screen.dart';
import 'package:greensundiary/diary/chart.dart';
import 'package:greensundiary/diary/view_created_diaries.dart';
import 'package:lottie/lottie.dart';
import 'package:social_share/social_share.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.user});
  final User user;

  ///todo: can move signOut functionality to drawer.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) {
    ///todo: obtain username from email.
    int index = user.email.indexOf('@') ?? 0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.circle,
              color: Colors.green,
            ),
            color: Colors.green,
            // onPressed: () {
            //   // return Scaffold.of(context).openDrawer();
            // },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.green,
            onPressed: () {
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  confirmBtnText: "Continue",
                  title: "Logout?",
                  text: "You will be returned to the authentication screen.",
                  animType: CoolAlertAnimType.slideInRight,
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                    _signOut().whenComplete(() {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AuthenticateAccount();
                      }));
                    });
                  });
            },
          ),
        ],
      ),
      //todo: drawer can be added from here.
      // drawer: HomeDrawer(
      //   user: user,
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton.icon(
          icon: Icon(FontAwesomeIcons.bookOpen),
          label: Text("Add new Diary"),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return AddDiaryScreen();
            }));
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
                  "Welcome ${user.email.substring(0, index)}, below is your green sun chart!",
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
                      icon: Icon(FontAwesomeIcons.share),
                      onPressed: () {
                        SocialShare.shareOptions(
                            "Hey friend, download green sun diary from google PlayStore and start updating your green sun.");
                      },
                      hoverColor: Colors.green,
                      iconSize: 25,
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.book),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ViewCreatedDiaries();
                          },
                        ));
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
                "Add a diary to unlock the chart, and more!",
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
