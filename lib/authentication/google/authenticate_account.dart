import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greensundiary/authentication/google/continue_with_google.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///I do the privacy policy link as follows.
    const _url = "https://www.websitepolicies.com/policies/view/w5FUCITc";
    launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    ///disabling landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.help_center_outlined),
            color: Colors.green,

            ///
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: new Icon(Icons.settings),
                          title: new Text('Privacy policy'),
                          onTap: () {
                            launchURL(_url);
                          },
                        ),
                        ListTile(
                          leading: new Icon(Icons.share),
                          title: new Text('Share'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton.icon(
          icon: Icon(FontAwesomeIcons.google),
          label: Text("Continue with google"),
          onPressed: () {
            Authentication.signInWithGoogle(context: context);
          },
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Welcome to your personal well-being companion!",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.5,
              ),
              SizedBox(
                height: 50,
              ),

              ///
              Lottie.asset("assets/images/walking.json",
                  height: MediaQuery.of(context).size.width),

              ///social media share icons.
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     IconButton(
              //       icon: Icon(FontAwesomeIcons.whatsapp),
              //       onPressed: () {},
              //       hoverColor: Colors.green,
              //       iconSize: 25,
              //     ),
              //     IconButton(
              //       icon: Icon(FontAwesomeIcons.twitter),
              //       onPressed: () {},
              //       hoverColor: Colors.green,
              //       iconSize: 25,
              //     ),
              //     IconButton(
              //       icon: Icon(FontAwesomeIcons.googlePlay),
              //       onPressed: () {},
              //       hoverColor: Colors.green,
              //       iconSize: 25,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
