import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:greensundiary/authentication/auth_bloc/signup/signup_validators.dart';
import 'package:greensundiary/main.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends Object with SignUpValidators {
  late FirebaseAuth _firebaseAuth;
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();

  //add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get confirmPassword =>
      _confirmPassword.stream.transform(validateConfirmPassword);

  Stream<bool> get submitValid =>
      Rx.combineLatest3(email, password, confirmPassword, (a, b, c) => true);

  //change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeConfirmPassword => _confirmPassword.sink.add;

  submit(BuildContext context) async {
    final validEmail = _email.value;
    final validPassword = _password.value;
    final validConfirmPassword = _confirmPassword.value;
    //check if the passwords match: else return snackBar.
    if (validPassword != validConfirmPassword) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match! Try again!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      FocusScope.of(context).unfocus();
      signUp(context, validEmail, validPassword);
      print(
          'Email is $validEmail and password is $validPassword and confirmPass is $validConfirmPassword');
    }
  }

  dispose() {
    _email.close();
    _password.close();
    _confirmPassword.close();
  }

  // SignUp function
  Future<void> signUp(
      BuildContext context, String userEmail, String userPassword) async {
    try {
      // create a new account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      //send an email verification after creating an account
      User? user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      //tell the user to check their email address for the verification link.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Success! Check your email address for the verification link!"),
            backgroundColor: Colors.green,
          ),
        );
      });
      //show login page by changing state
      //I decide to do this because it will default to the login interface.
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return MyApp();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Email address already registered! Login or reset password!"),
              backgroundColor: Colors.redAccent,
            ),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error has occurred please try again!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
