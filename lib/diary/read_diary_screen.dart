import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadDiaryScreen extends StatelessWidget {
  ReadDiaryScreen({required this.diaryId, required this.userID});
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
        backgroundColor: Colors.green.shade200,
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     color: Colors.green,
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
      ),
//
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade200,
        onPressed: () {},
        child: Icon(Icons.share),
      ),
      //
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                  future: users.doc(diaryId).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "Something went wrong!",
                        style: TextStyle(fontFamily: "Montserrat"),
                      );
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text(
                        "Document does not exist",
                        style: TextStyle(fontFamily: "Montserrat"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic>? data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                data?['dateCreated'],
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.green.shade300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  data?['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                  textScaleFactor: 1.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data?['body'],
                            textScaleFactor: 1.4,
                            style: TextStyle(fontFamily: "Montserrat"),
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
