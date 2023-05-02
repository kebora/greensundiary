import 'package:flutter/material.dart';
import 'package:greensundiary/authentication/auth_bloc/login/reset_password/rp_bloc/rp_bloc.dart';

class RPProvider extends InheritedWidget {
  final bloc = RPBloc();

  RPProvider({Key? key, required Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static RPBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<RPProvider>())!.bloc;
  }
}
