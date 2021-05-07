import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pie_chart/pie_chart.dart';

class Chart extends StatelessWidget {
  Chart({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    ///
    CollectionReference userMood =
        FirebaseFirestore.instance.collection('moods');

    return FutureBuilder<DocumentSnapshot>(
        future: userMood.doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Could not retrieve data! Check your connection.");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.exists) {
              return PieChart(
                colorList: [
                  Colors.green,
                  Colors.blue,
                  Colors.red,
                ],
                dataMap: {
                  "Greens": snapshot.data['greenSun'] + .0,
                  "Blues": snapshot.data['blueSun'] + .0,
                  "Reds": snapshot.data['redSun'] + .0,
                },
                chartRadius: MediaQuery.of(context).size.width / 2,
                legendOptions:
                    LegendOptions(legendPosition: LegendPosition.bottom),
              );
            } else {
              return Column(
                children: [
                  Lottie.asset('assets/images/emptychart.json',
                      height: MediaQuery.of(context).size.width / 2),
                  Text("No data available!"),
                ],
              );
            }
          }
          return Text("No charts available!");
        });
  }
}
