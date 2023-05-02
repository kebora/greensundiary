import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth_bloc/auth_bloc.dart';
import 'package:greensundiary/constants.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/logo/logo_switch.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //login bloc
    final bloc = LoginProvider.of(context);
    //reset password bloc
    final rpBloc = RPProvider.of(context);
    return Card(
      margin: EdgeInsets.all(20),
      child: Container(
        height: MediaQuery.of(context).size.width + 120,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: LogoSwitch(),
              ),
              _SizedBox(size: sizedBoxHeight),
              //email address
              _InputEmailAddress(
                bloc: bloc,
              ),
              _SizedBox(size: sizedBoxHeight),
              //password
              _InputPassword(
                bloc: bloc,
              ),
              _SizedBox(size: sizedBoxHeight),
              //login button
              _LoginButton(context: context, bloc: bloc),
              //Forgot password
              _ResetPassword(rpBloc: rpBloc),
              _GoogleAccount(context: context, bloc: bloc),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputEmailAddress extends StatelessWidget {
  const _InputEmailAddress({Key? key, required this.bloc}) : super(key: key);
  final LoginBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.email,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
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
}

class _InputPassword extends StatelessWidget {
  const _InputPassword({Key? key, required this.bloc}) : super(key: key);
  final LoginBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changePassword,
            obscureText: true,
            decoration: InputDecoration(
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
}

class _SizedBox extends StatelessWidget {
  const _SizedBox({Key? key, required this.size}) : super(key: key);
  final size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
    );
  }
}

//Define the login button
class _LoginButton extends StatelessWidget {
  _LoginButton({required this.context, required this.bloc});
  final BuildContext context;
  final LoginBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.submitValid,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData ? function1 : null,
            child: Text(
              "LogIn",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          );
        });
  }
  /*
  I have functions 1 and 2 in order to avoid the passing directly of a function
  that accepts parameters into the onPressed() of the button. Doing that removes the
  effect of disable button until the inputs are valid, which is defined in the bloc.
   */

  //func 1
  void function1() {
    return function2(context, bloc);
  }

  //func 2
  void function2(context, bloc) {
    return bloc.submit(context);
  }
}

class _ResetPassword extends StatelessWidget {
  const _ResetPassword({Key? key, required this.rpBloc}) : super(key: key);
  final RPBloc rpBloc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: Colors.blue,
            fontFamily: "Montserrat",
          ),
        ),
        onPressed: () => _showIt(context, rpBloc),
      ),
    );
  }
}

//on pressing the forgot password option, show the modal bottom sheet
//I am handling the reset password bloc here.
class _SendPasswordLinkButton extends StatelessWidget {
  _SendPasswordLinkButton({required this.context, required this.rpBloc});
  final BuildContext context;
  final RPBloc rpBloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: rpBloc.submitValid,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData ? function1 : null,
            child: Text(
              "Send Reset Link",
              style: TextStyle(fontFamily: "Montserrat"),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          );
        });
  }

  /*
  I have functions 1 and 2 in order to avoid the passing directly of a function
  that accepts parameters into the onPressed() of the button. Doing that removes the
  effect of disable button until the inputs are valid, which is defined in the bloc.
   */

  //func 1
  void function1() {
    return function2(context, rpBloc);
  }

  //func 2
  void function2(context, rpBloc) {
    return rpBloc.submit(context);
  }
}

_showIt(BuildContext inContext, RPBloc rpBloc) {
  showModalBottomSheet(
      context: inContext,
      builder: (BuildContext inContext) {
        return Card(
          margin: EdgeInsets.all(20.0),
          child: Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                StreamBuilder<Object>(
                    stream: rpBloc.email,
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: rpBloc.changeEmail,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Enter Email address",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      );
                    }),
                _SendPasswordLinkButton(
                  context: inContext,
                  rpBloc: rpBloc,
                ),
                TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontFamily: "Montserrat"),
                    ),
                    onPressed: () {
                      Navigator.of(inContext).pop();
                    }),
              ]),
            ),
          ),
        );
      });
}

//create a new account
class _GoogleAccount extends StatelessWidget {
  _GoogleAccount({required this.context, required this.bloc});
  final BuildContext context;
  final LoginBloc bloc;

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
  final LoginBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.submitValid,
        builder: (context, snapshot) {
          return SizedBox(
            height: 45,
            child: ElevatedButton.icon(
              label: const Text(
                'CONTINUE WITH GOOGLE',
                style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              icon: Icon(FontAwesomeIcons.google, color: Colors.white),
              onPressed: snapshot.hasData ? null : function1,
            ),
          );
        });
  }

  //func 1
  void function1() {
    return function2(context, bloc);
  }

  //func 2
  void function2(context, bloc) async {
    User? user = await Authentication.signInWithGoogle(context: context);

    ///If a user is found then we can pass the data to the HomeScreen.
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
        ),
      );
    }
  }
}
