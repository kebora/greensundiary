import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadDiaryScreen extends StatelessWidget {
  ReadDiaryScreen({this.diaryId, this.userID});
  final String diaryId;
  final String userID;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection("diaries")
        .doc(userID)
        .collection("Diaries");
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
          // IconButton(
          //   icon: Icon(Icons.share_outlined),
          //   color: Colors.green,
          //   onPressed: () {},
          // ),
        ],
      ),
      //todo: add the sharing option to the application.
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: OutlinedButton.icon(
      //     icon: Icon(FontAwesomeIcons.share),
      //     label: Text("share"),
      //
      //     ///share the data with a friend.
      //     onPressed: () {},
      //     style: ElevatedButton.styleFrom(
      //       side: BorderSide(width: 1.0, color: Colors.blue),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(32.0),
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                  future: users.doc(diaryId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong!");
                    }

                    ///todo: in this section, I will have to add a nicer placeholder,
                    /// like an interactive cat in a box. and a redirect button to create
                    /// new diary.
                    if (snapshot.hasData && !snapshot.data.exists) {
                      return Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data();
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                data['dateCreated'],
                                textScaleFactor: 1.5,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data['title'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textScaleFactor: 1.5,
                              ),
                            ],
                          ),
                          Text(
                            data['body'],
                            textScaleFactor: 1.3,
                          ),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
