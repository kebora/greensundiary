import 'dart:async';

class Validators {
  final validateTitle = StreamTransformer<String, String>.fromHandlers(
      handleData: (titleText, sink) {
    if (titleText == null && titleText.length < 3) {
      sink.addError("Title should be more than 3 characters!");
    } else {
      sink.add(titleText);
    }
  });

  final validateBody = StreamTransformer<String, String>.fromHandlers(
      handleData: (bodyText, sink) {
    if (bodyText == null && bodyText.length < 10) {
      sink.addError("Body should be at least 10 characters!");
    } else {
      sink.add(bodyText);
    }
  });
}
