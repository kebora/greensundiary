import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:rxdart/rxdart.dart';

import 'login_validators.dart';

class LoginBloc extends Object with LoginValidators {
  // database configurations
  final _auth = FirebaseAuth.instance;
  late UserCredential _userCredential;
  //
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  //add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (a, b) => true);

  //change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final validEmail = _email.value;
    final validPassword = _password.value;
    //call the signIn function and pass the valid values.
    signIn(
        context: context, userEmail: validEmail!, userPassword: validPassword!);
    print('Email is $validEmail and password is $validPassword');
  }

  dispose() {
    _email.close();
    _password.close();
  }

  //signIn function
  Future<void> signIn(
      {required BuildContext context, required String userEmail, required String userPassword}) async {
    try {
      _userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      User? user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        //If I choose to send a verification link again,
        // that would be extravagant, so I decide not to do that.
        // await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Check your email for the verification link!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        //openHomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: user,
            ),
          ),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
