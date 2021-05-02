import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.photoURL),
                  ),
                ),
                Text(
                  user.email,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Personal Data"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.peopleArrows),
            title: Text("Counselors"),
            subtitle: Text("Share your data and get helped if ratio is low!"),
          ),
          ListTile(
            title: Text("Privacy and Settings"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Theme"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.globeEurope),
            title: Text("Developer updates"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.googlePlay),
            title: Text("Rate application"),
          ),
        ],
      ),
    );
  }
}
