import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greensundiary/diary/bloc/validators.dart';
import 'package:greensundiary/diary/view_created_diaries.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators {
  User? user = FirebaseAuth.instance.currentUser;

  ///reference of the diaries
  CollectionReference diaries =
      FirebaseFirestore.instance.collection("diaries");

  ///reference of the moods
  CollectionReference moods = FirebaseFirestore.instance.collection("moods");
  final _titleText = BehaviorSubject<String>();
  final _bodyText = BehaviorSubject<String>();

  ///add data to stream
  Stream<String> get titleText => _titleText.stream.transform(validateTitle);
  Stream<String> get bodyText => _bodyText.stream.transform(validateBody);

  Stream<bool> get submitValid =>
      Rx.combineLatest2(titleText, bodyText, (a, b) => true);

  ///change the data
  Function(String) get changeTitleText => _titleText.sink.add;
  Function(String) get changeBodyText => _bodyText.sink.add;

  submit(BuildContext context, String selectedDate, String mood) async {
    final validTitleText = _titleText.value;
    final validBodyText = _bodyText.value;

    ///check if that is the first record and make the fields:
    ///greens, blues and reds, all initialized to 0.
    ///I do this by checking whether there exists any record in the db.
    await getDoc();
    await submitDetailsToDB(
        context, selectedDate, mood, validTitleText, validBodyText);
  }

  Future getDoc() async {
    var a = await FirebaseFirestore.instance
        .collection('moods')
        .doc(user!.uid)
        .get();
    if (a.exists) {
      print('Exists');

      ///increment the number
      return a;
    }
    if (!a.exists) {
      print('Not exists');

      ///create a new collection and initialize all moods to zero.
      await FirebaseFirestore.instance.collection('moods').doc(user!.uid).set({
        'greenSun': 0,
        'blueSun': 0,
        'redSun': 0,
      });
    }
  }

  ///This function updates the records of the mood.
  updateMoodRecords(BuildContext context, String fieldToUpdate) async {
    await moods.doc(user!.uid).update({
      fieldToUpdate: FieldValue.increment(1),
    });
  }

  submitDetailsToDB(
    BuildContext context,
    String selectedDate,
    String mood,
    String validTitleText,
    String validBodyText,
  ) async {
    // ignore: unnecessary_null_comparison
    if (validBodyText != null) {
      ///store the details in the database.
      await diaries.doc(user!.uid).collection("Diaries").doc().set({
        ///convert to date and see what happens.
        'dateCreated': selectedDate,
        'title': validTitleText,
        'body': validBodyText,
        'mood': mood,
        'email': user!.email,
      }).whenComplete(() async {
        Navigator.of(context).pop();

        ///
        if (mood == "Mood.greenSun") {
          await updateMoodRecords(context, 'greenSun');
        } else if (mood == "Mood.blueSun") {
          await updateMoodRecords(context, 'blueSun');
        } else {
          await updateMoodRecords(context, 'redSun');
        }

        ///
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ViewCreatedDiaries();
        }));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Diary added successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }).onError((error, stackTrace) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An error has been experienced, try again!"),
          backgroundColor: Colors.red,
        ));
      });
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Check the formatting of the title and body and try again!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  dispose() {
    _titleText.close();
    _bodyText.close();
  }
}
