import 'package:bloc/bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_event.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_state.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(StateA());

  @override
  Stream<MyState> mapEventToState(MyEvent event) async* {
    switch (event) {
      case MyEvent.eventA:
        yield StateA();
        break;
      case MyEvent.eventB:
        yield StateB();
        break;
    }
  }
}
