import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/auth_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_bloc.dart';
import 'package:greensundiary/authentication/auth_screen_login.dart';
import 'package:greensundiary/authentication/auth_screen_signup.dart';

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SignUpProvider(
      child: LoginProvider(
        child: RPProvider(
          child: Scaffold(
            body: Center(
              child: BlocBuilder<SwitchCubit, bool>(
                builder: (_, state) =>
                    state == false ? LoginScreen() : SignUpScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
