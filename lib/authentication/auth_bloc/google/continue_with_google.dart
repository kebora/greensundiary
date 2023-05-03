import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:greensundiary/home/home_screen.dart';
import 'package:greensundiary/main.dart';

class Authentication {
  //create an instance of the google sign in class
  final googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
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
      // log(user.email.toString());
      await user.updateEmail(account.email).whenComplete(() {
        Get.off(HomeScreen(user: user));
      });
    } catch (e) {
      Get.snackbar(
        "Oops!",
        "${e.toString()}",
      );
    }
  }

  //
  void handleSignOut() async {
    googleSignIn.signOut().whenComplete(() {
      Get.offAll(LogoutWidget());
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
