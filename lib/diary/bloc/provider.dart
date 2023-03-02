import 'package:flutter/material.dart';
import 'package:greensundiary/diary/bloc/bloc.dart';

class Provider extends InheritedWidget {
  final bloc = Bloc();

  Provider({Key? key, required Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static Bloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())!.bloc;
  }
}
