import 'package:cloud_firestore/cloud_firestore.dart';
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
  HomeScreen({this.user});
  final User user;

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pop();
    }).whenComplete(() => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return MyApp();
        })));
  }

  Widget _logoutThemePopUp(BuildContext context) {
    return new AlertDialog(
      title: const Text('My Account'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //todo: dark theme here.
          // ListTile(
          //   title: Text("Change Theme"),
          //   leading: Icon(Icons.wb_sunny),
          //   onTap: () {},
          // ),
          ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                _signOut(context);
              }),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    ///todo: obtain username from email.
    int index = user.email.indexOf('@') ?? 0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white10,
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Account Management"),
                        content: Text(accountDeactivation),
                      );
                    });
              })
        ],
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.circle,
              color: Colors.green,
            ),
            color: Colors.green,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _logoutThemePopUp(context));
            },
          ),
        ),
      ),
      //todo: drawer can be added from here.
      // drawer: HomeDrawer(
      //   user: user,
      // ),
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
