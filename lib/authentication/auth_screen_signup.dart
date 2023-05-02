import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greensundiary/authentication/auth_bloc/google/continue_with_google.dart';
import 'package:greensundiary/authentication/auth_bloc/signup/signup_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/signup/signup_provider.dart';
import 'package:greensundiary/constants.dart';
import 'package:greensundiary/logo/logo_switch.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //The provider for the signUpScreen.
    final bloc = SignUpProvider.of(context);
    return Card(
      margin: EdgeInsets.all(20),
      child: Container(
        height: MediaQuery.of(context).size.width + 120,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: LogoSwitch(),
              ),
              _sizedBoxF(sizedBoxHeight),
              //email address
              _inputEmailAddress(bloc),
              _sizedBoxF(sizedBoxHeight),
              //password
              _inputPassword(bloc),
              _sizedBoxF(sizedBoxHeight),
              _inputConfirmPassword(bloc),
              _sizedBoxF(5.0),
              //create account button
              _SignUpButton(context: context, bloc: bloc),
              _sizedBoxF(3.0),
              //Forgot password
              _GoogleAccount(context: context, bloc: bloc),
            ],
          ),
        ),
      ),
    );
  }
}

//input email address
Widget _inputEmailAddress(SignUpBloc bloc) {
  return StreamBuilder<Object>(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: snapshot.error.toString(),
            filled: true,
            hintText: "Email",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        );
      });
}

//input password
Widget _inputPassword(SignUpBloc bloc) {
  return StreamBuilder<Object>(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            errorText: snapshot.error.toString(),
            filled: true,
            hintText: "Password",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        );
      });
}

//input password
Widget _inputConfirmPassword(SignUpBloc bloc) {
  return StreamBuilder<Object>(
      stream: bloc.confirmPassword,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeConfirmPassword,
          obscureText: true,
          decoration: InputDecoration(
            errorText: snapshot.error.toString(),
            filled: true,
            hintText: "Confirm Password",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        );
      });
}

//define the space between the widgets in the card
Widget _sizedBoxF(size) {
  return SizedBox(
    height: size,
  );
}

//Define the signUp button
class _SignUpButton extends StatefulWidget {
  _SignUpButton({required this.context, required this.bloc});
  final BuildContext context;
  final SignUpBloc bloc;
  final isLoading = false;
  @override
  __SignUpButtonState createState() =>
      __SignUpButtonState(context, bloc, isLoading);
}

class __SignUpButtonState extends State<_SignUpButton> {
  __SignUpButtonState(this.context, this.bloc, this.isLoading);
  final BuildContext context;
  final SignUpBloc bloc;
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.bloc.submitValid,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData ? function1 : null,
            child: isLoading == false
                ? Text("Create Account")
                : Lottie.asset('assets/images/triangleload.json', width: 50),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          );
        });
  }

  function1() {
    return function2(widget.context, widget.bloc);
  }

  function2(context, bloc) {
    setState(() {
      isLoading = true;
    });
    return bloc.submit(context);
  }
}

//create a new account
class _GoogleAccount extends StatelessWidget {
  _GoogleAccount({required this.context, required this.bloc});
  final BuildContext context;
  final SignUpBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GoogleAccountButton(
            context: context,
            bloc: bloc,
          )
        ],
      ),
    );
  }
}

//Google Account Button
class _GoogleAccountButton extends StatelessWidget {
  _GoogleAccountButton({required this.context, required this.bloc});
  final BuildContext context;
  final SignUpBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.submitValid,
        builder: (context, snapshot) {
          return ElevatedButton.icon(
            label: const Text(
              'CONTINUE WITH GOOGLE',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            icon: Icon(FontAwesomeIcons.google, color: Colors.white),
            onPressed: snapshot.hasData ? null : function1,
          );
        });
  }

  //func 1
  void function1() {
    return function2(context, bloc);
  }

  //func 2
  void function2(context, bloc) async {
    // ignore: unused_local_variable
    User? user = await Authentication.signInWithGoogle(context: context);
    //If a user is found then we can pass the data to the HomeScreen.
  }
}
