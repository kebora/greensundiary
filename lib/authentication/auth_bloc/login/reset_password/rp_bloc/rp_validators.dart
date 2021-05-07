import 'dart:async';

//RP => Reset Password
class RPValidators {
  //regex for email
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length != 0 && _emailRegExp.hasMatch(email))
      sink.add(email);
    else
      sink.addError("Email invalid!");
  });
}
