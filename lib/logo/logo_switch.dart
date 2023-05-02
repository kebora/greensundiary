import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_bloc.dart';
import 'package:lottie/lottie.dart';

//smile smiley logo switch
class LogoSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: MediaQuery.of(context).size.width / 2,
      child: BlocBuilder<SwitchCubit, bool>(
        builder: (_, state) =>
            state == false ? viewOne(context) : viewTwo(context),
      ),
    ));
  }
}

///shown on login mode.
Widget viewOne(BuildContext context) {
  return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Lottie.asset('assets/images/upwards.json', width: 70),
          Image.asset(
            'assets/images/smilelogo.png',
            width: MediaQuery.of(context).size.width / 4,
          ),
        ],
      ),
      onTap: () => context.read<SwitchCubit>().switchView());
}

//shown when it is changed.
Widget viewTwo(BuildContext context) {
  return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/smilelogo.png',
            width: MediaQuery.of(context).size.width / 4,
          ),
          RotationTransition(
            child: Lottie.asset('assets/images/upwards.json', width: 70),
            turns: AlwaysStoppedAnimation(180 / 360),
          ),
        ],
      ),
      onTap: () => context.read<SwitchCubit>().switchView());
}
