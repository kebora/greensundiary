import 'package:automate_alert/automate_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greensundiary/diary/read_diary_screen.dart';

///I choose to display the following categories based on user filter choice.
enum Categories { onlyGreen, onlyBlue, onlyRed, allView }

///
class ViewCreatedDiaries extends StatefulWidget {
  @override
  _ViewCreatedDiariesState createState() => _ViewCreatedDiariesState();
}

class _ViewCreatedDiariesState extends State<ViewCreatedDiaries> {
  Categories _currentView = Categories.allView;
  User user = FirebaseAuth.instance.currentUser;

  ///the popUp function that allows filtration.
  Widget _changeQueryDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Select the desired category."),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Greens"),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
              ),
              onTap: () {
                _currentView = Categories.onlyGreen;
                setState(() {});
              },
            ),
            ListTile(
              title: Text("Blues"),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
              ),
              onTap: () {
                _currentView = Categories.onlyBlue;
                setState(() {});
              },
            ),
            ListTile(
              title: Text("Reds"),
              leading: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              onTap: () {
                _currentView = Categories.onlyRed;
                setState(() {});
              },
            ),
            ListTile(
              title: Text("View all"),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
              ),
              trailing: Icon(Icons.workspaces_filled),
              onTap: () {
                _currentView = Categories.allView;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///disable landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    ///a query for diary deletion
    Future<void> _deleteDiary(String id) {
      return FirebaseFirestore.instance
          .collection("diaries")
          .doc(user.uid)
          .collection("Diaries")
          .doc(id)
          .delete()
          .then((value) => print("Deleted successfully!"))
          .catchError((onError) => print("Failed to delete record!"))
          .whenComplete(() {});
    }

    ///getting all the data back.
    Stream documentStream = FirebaseFirestore.instance
        .collection("diaries")
        .doc(user.uid)
        .collection("Diaries")
        .orderBy('dateCreated', descending: true)
        .snapshots();

    ///get only the greens
    Stream greenStream = FirebaseFirestore.instance
        .collection("diaries")
        .doc(user.uid)
        .collection("Diaries")
        .where('mood', isEqualTo: "Mood.greenSun")
        .snapshots();

    ///get only the blues
    Stream blueStream = FirebaseFirestore.instance
        .collection("diaries")
        .doc(user.uid)
        .collection("Diaries")
        .where('mood', isEqualTo: "Mood.blueSun")
        .snapshots();

    ///get only the reds
    Stream redStream = FirebaseFirestore.instance
        .collection("diaries")
        .doc(user.uid)
        .collection("Diaries")
        .where('mood', isEqualTo: "Mood.redSun")
        .snapshots();

    ///
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_sharp),
            color: Colors.green,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _changeQueryDialog(context));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: _currentView == Categories.onlyRed
                    ? redStream
                    : _currentView == Categories.onlyBlue
                        ? blueStream
                        : _currentView == Categories.onlyGreen
                            ? greenStream
                            : documentStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong!");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data.docs[index];
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    document.data()['dateCreated'],
                                    style: TextStyle(),
                                    textScaleFactor: 1.5,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return ReadDiaryScreen(
                                        diaryId: document.id,
                                        userID: user.uid,
                                      );
                                    }));
                                  },
                                  leading: CircleAvatar(
                                    ///sequential counter.
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: document.data()['mood'] ==
                                            "Mood.blueSun"
                                        ? Colors.blue
                                        : document.data()['mood'] ==
                                                "Mood.greenSun"
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  trailing: GestureDetector(
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          animType:
                                              CoolAlertAnimType.slideInRight,
                                          text:
                                              "Confirm you want to delete ${document.data()['title']}?",
                                          confirmBtnText: "Delete",
                                          cancelBtnText: "Cancel",
                                          borderRadius: 5,
                                          confirmBtnColor:
                                              document.data()['mood'] ==
                                                      "Mood.blueSun"
                                                  ? Colors.blue
                                                  : document.data()['mood'] ==
                                                          "Mood.greenSun"
                                                      ? Colors.green
                                                      : Colors.red,
                                          onConfirmBtnTap: () {
                                            _deleteDiary(document.id)
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            }).whenComplete(() {
                                              return AlertNoServerAutoDialog(
                                                  context: context,
                                                  alertAnimateType:
                                                      AlertAnimateType
                                                          .SlowAppear,
                                                  message:
                                                      "Diary record deleted successfully!",
                                                  alertType: AlertType.Success,
                                                  showDuration: 2)
                                                ..show();
                                            });
                                          });

                                      ///
                                    },
                                  ),
                                  subtitle: Text(
                                    document.data()['title'],
                                    textScaleFactor: 1.5,
                                  ),
                                  // horizontalTitleGap: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
