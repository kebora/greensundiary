import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_bloc.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_event.dart';
import 'package:greensundiary/authentication/auth_bloc/logo_bloc/logo_movement_state.dart';
import 'package:lottie/lottie.dart';

//smile smiley logo switch
class LogoSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: MediaQuery.of(context).size.width / 2,
      child: BlocBuilder<MyBloc, MyState>(
        builder: (_, state) =>
            state is StateA ? viewOne(context) : viewTwo(context),
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
    onTap: () {
      BlocProvider.of<MyBloc>(context).add(MyEvent.eventB);
    },
  );
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

        // Lottie.asset('assets/images/imageupload.json', width: 60),
        RotationTransition(
          child: Lottie.asset('assets/images/upwards.json', width: 70),
          turns: AlwaysStoppedAnimation(180 / 360),
        ),
      ],
    ),
    onTap: () {
      BlocProvider.of<MyBloc>(context).add(MyEvent.eventA);
    },
  );
}
//shown when it is changed.

///shown when in signUp mode. I have done this to allow the user select and
///preview the image before upload to database.
// class _ViewTwo extends StatefulWidget {
//   _ViewTwo({this.context});
//   final BuildContext context;
//   @override
//   __ViewTwoState createState() => __ViewTwoState(context);
// }
//
// class __ViewTwoState extends State<_ViewTwo> {
//   __ViewTwoState(context);
//   BuildContext context;
//   File _image;
//   final picker = ImagePicker();
//   Future getImage() async {
//     PickedFile pickedFile = await ImagePicker().getImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       await cropImage(pickedFile.path).onError((error, stackTrace) {
//         return Fluttertoast.showToast(
//             msg: "No image selected!", backgroundColor: Colors.red);
//       });
//     }
//   }
//
//   ///crop image
//   Future cropImage(filePath) async {
//     File croppedImage = await ImageCropper.cropImage(
//         sourcePath: filePath, cropStyle: CropStyle.circle);
//     setState(() {
//       _image = File(croppedImage.path);
//     });
//   }
//
//   ///
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: ListView(children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Image.asset(
//               _image == null ? 'assets/images/smilelogo.png' : _image,
//               width: MediaQuery.of(context).size.width / 4,
//             ),
//             GestureDetector(
//               child: Lottie.asset('assets/images/imageupload.json', width: 50),
//               onTap: () {
//                 getImage();
//               },
//             ),
//           ],
//         ),
//       ]),
//       onTap: () {
//         BlocProvider.of<MyBloc>(context).add(MyEvent.eventA);
//       },
//     );
//   }
// }
