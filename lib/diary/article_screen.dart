import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:social_share/social_share.dart';

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("news");
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            body: SafeArea(
                child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                        future: users.doc("greensundiary").get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong!");
                          }

                          ///todo: in this section, I will have to add a nicer placeholder,
                          /// like an interactive cat in a box. and a redirect button to create
                          /// new diary.
                          if (snapshot.hasData && !snapshot.data.exists) {
                            return Text("Document does not exist");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data = snapshot.data.data();
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        data['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textScaleFactor: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  data['body'],
                                  textScaleFactor: 1.3,
                                ),
                                Text(
                                  data['writer'],
                                  textScaleFactor: 1.5,
                                ),
                                Text(
                                  data['email'],
                                  textScaleFactor: 1.3,
                                ),
                              ],
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                  ],
                ),
              ),
            )),
          ),
          MarqueeText(),

          ///
        ],
      ),
    );
  }
}

///I decide to display this at the bottom of the page.
class MarqueeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("news");
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc("greensundiary").get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong!");
            }
            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.twitter,
                          color: Colors.blue,
                          size: 30,
                        ),
                        onPressed: () {
                          print("The twitter username is @${data['twitter']}");
                          print("The title is ${data['title']}");
                          SocialShare.shareTwitter(
                              "Hey, download Green Sun Diary application on PlayStore and check out today's mental health article by @${data['twitter']} about ${data['title']}",
                              hashtags: ["greensundiary"],
                              url: "");
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                        ),
                        iconSize: 30,
                        onPressed: () {
                          SocialShare.shareWhatsapp(
                              "Hey, download Green Sun Diary application on PlayStore and check out today's mental health article by ${data['writer']} about ${data['title']}");
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 0,
                    ),
                    height: 20,
                    color: Colors.green,
                    child: Center(
                      child: Marquee(
                        text:
                            "GreenSun ${DateTime.now().year} : ${data['marquee']} ",
                        velocity: 40,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
                child: Text(
              "Could not get the updates right now!",
              textScaleFactor: 1.3,
            ));
          }),
    );
  }
}
