import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greensundiary/authentication/auth_bloc/login/reset_password/rp_bloc/rp_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

//
class RPBloc extends Object with RPValidators {
  final _auth = FirebaseAuth.instance;
  final _email = BehaviorSubject<String>();
  //add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);

  //In this case I am using only one field, so I decide to take this approach.
  Stream<bool> get submitValid => email.map((email) => true);

  //change data
  Function(String) get changeEmail => _email.sink.add;

  submit(BuildContext context) async {
    final validEmail = _email.value;
    //check if user already exists in the database before sending a reset link.
    await _auth.sendPasswordResetEmail(email: validEmail).whenComplete(() {
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
      Get.snackbar(
        "Sending reset email...",
        "Check your inbox",
      );
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar(
        "Error",
        error.toString(),
      );
    });
  }

  dispose() {
    _email.close();
  }
}
