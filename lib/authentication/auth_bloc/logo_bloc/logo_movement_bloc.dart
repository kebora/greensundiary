import 'package:bloc/bloc.dart';

class SwitchCubit extends Cubit<bool> {
  SwitchCubit() : super(false);
  // when the button is clicked
  void switchView() => emit(!state);
}
