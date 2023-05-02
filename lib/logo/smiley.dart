import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';

class Smiley extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          gradient: new SweepGradient(
            startAngle: 0,
            endAngle: 70,
            tileMode: TileMode.repeated,
            colors: [Colors.white, Colors.green, Colors.transparent],
          ),
        ),
        child: Center(
          child: CircularText(
            children: [
              TextItem(
                text: Text(
                  "..................".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                space: 12,
                startAngle: -90,
                startAngleAlignment: StartAngleAlignment.center,
                direction: CircularTextDirection.clockwise,
              ),
              TextItem(
                text: Text(
                  "green sun diary".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                space: 10,
                startAngle: 90,
                startAngleAlignment: StartAngleAlignment.center,
                direction: CircularTextDirection.anticlockwise,
              ),
            ],
            radius: 80,
            position: CircularTextPosition.outside,
            backgroundPaint: Paint()..color = Colors.green,
          ),
        ),
      ),
    );
  }
}
