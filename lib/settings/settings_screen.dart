import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greensundiary/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_share/social_share.dart';

Future<void> _launchUrl(_url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection("news");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: Text(
          "Post of the Day",
          style: textStyleBold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc("greensundiary").get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      "Something went wrong!",
                      style: textStyleNormal,
                    );
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text(
                      "Document does not exist",
                      style: textStyleNormal,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic>? data =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    return Column(
                      children: [
                        Text(
                          data?['writer'],
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 20,
                          ),
                        ),
                        Column(
                          children: [
                            ListTile(
                              title: Text(
                                data?['title'],
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final Uri _url =
                                      Uri.parse('${data?["article_url"]}');
                                  await _launchUrl(_url);
                                },
                                child: Text(
                                  "Read",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                                SocialShare.shareTwitter(
                                    "Hey, download Green Sun Diary application on PlayStore and check out today's update by ${data?['writer']} about ${data?['title']}",
                                    hashtags: [
                                      "greensundiary",
                                    ],
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
                                    "Hey, download Green Sun Diary application on PlayStore and check out today's update by ${data?['writer']} about ${data?['title']}");
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}
