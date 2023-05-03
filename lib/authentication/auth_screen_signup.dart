import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth_bloc/auth_bloc.dart';
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
              _SizedBox(size: sizedBoxHeight),
              _InputEmailAddress(
                bloc: bloc,
              ),
              _SizedBox(size: sizedBoxHeight),
              _InputPassword(
                bloc: bloc,
              ),
              _SizedBox(size: sizedBoxHeight),
              _InputConfirmPassword(
                bloc: bloc,
              ),
              _SizedBox(size: sizedBoxHeight),
              _SignUpButton(context: context, bloc: bloc),
              _SizedBox(size: sizedBoxHeight),
              _GoogleAccount(context: context, bloc: bloc),
            ],
          ),
        ),
      ),
    );
  }
}

//input email address
class _InputEmailAddress extends StatelessWidget {
  const _InputEmailAddress({Key? key, required this.bloc}) : super(key: key);
  final SignUpBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.email,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
            ),
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

//input password
class _InputPassword extends StatelessWidget {
  const _InputPassword({Key? key, required this.bloc}) : super(key: key);
  final SignUpBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
            ),
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

class _InputConfirmPassword extends StatelessWidget {
  const _InputConfirmPassword({Key? key, required this.bloc}) : super(key: key);
  final SignUpBloc bloc;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.confirmPassword,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 18,
            ),
            onChanged: bloc.changeConfirmPassword,
            obscureText: true,
            decoration: InputDecoration(
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
                ? Text(
                    "Create Account",
                    style: TextStyle(fontFamily: "Montserrat"),
                  )
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
    return SizedBox(
      height: 45,
      child: StreamBuilder<Object>(
          stream: bloc.submitValid,
          builder: (context, snapshot) {
            return ElevatedButton.icon(
                label: const Text(
                  'CONTINUE WITH GOOGLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300),
                icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                onPressed: () => Authentication().handleSignIn());
          }),
    );
  }
}
