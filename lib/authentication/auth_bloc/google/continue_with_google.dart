import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/my_application.dart';

class Authentication {
  //create an instance of the google sign in class
  final googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content: 'The account already exists with a different credential',
          //   ),
          // );
        } else if (e.code == 'invalid-credential') {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content: 'Error occurred while accessing credentials. Try again.',
          //   ),
          // );
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   Authentication.customSnackBar(
        //     content: 'Error occurred using Google Sign In. Try again.',
        //   ),
        // );
      }
      //
    }

    return user;
  }

  //
  void handleSignIn() async {
    try {
      final account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      log(user.email.toString());
      await user.updateEmail(account.email).whenComplete(() {
        Get.off(HomeScreen(user: user));
      });
    } catch (e) {
      log("${e.toString()}");
      Get.snackbar(
        "Oops!",
        "${e.toString()}",
      );
    }
  }

  //
  void handleSignOut() async {
    googleSignIn.signOut().whenComplete(() {
      Get.offAll(MyApplication());
    });
  }

  //
  void handAuthStateChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Get.off(HomeScreen(user: user));
      }
    });
  }

  //
}
