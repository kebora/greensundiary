import 'package:flutter/material.dart';
import 'package:greensundiary/authentication/auth_bloc/login/login_bloc.dart';

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginProvider({Key? key, required Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LoginProvider>())!.bloc;
  }
}
