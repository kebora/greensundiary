import 'dart:async';

class SignUpValidators {
  int numOfCharacters;
  //regex for email
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  //regex for password
  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.length != 0 && _emailRegExp.hasMatch(email))
      sink.add(email);
    else
      sink.addError("Email invalid!");
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5 && _passwordRegExp.hasMatch(password))
      sink.add(password);
    else
      sink.addError("Password is weak!");
  });

  final validateConfirmPassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (confirmPassword, sink) {
    if (confirmPassword.length > 5 && _passwordRegExp.hasMatch(confirmPassword))
      sink.add(confirmPassword);
    else
      sink.addError("Passwords do not match!");
  });
}
