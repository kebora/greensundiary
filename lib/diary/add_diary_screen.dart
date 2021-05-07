import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greensundiary/diary/bloc/bloc.dart';
import 'package:intl/intl.dart';

enum Mood { greenSun, blueSun, redSun }

class AddDiaryScreen extends StatefulWidget {
  @override
  _AddDiaryScreenState createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  Mood mood = Mood.greenSun;
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      selectableDayPredicate: _decideWhichDayToEnable,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 10))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();

    ///final selected and formatted date that I decide to send to DB.
    String finalSelected = DateFormat.yMMMEd().format(selectedDate);
    return Scaffold(
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
        actions: [
          IconButton(
            icon: Icon(Icons.camera),
            color: Colors.green,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: new Icon(Icons.wb_twighlight),
                          title: new Text(
                              'It\'s okay not to be okay. No one is perfect!'),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      bottomNavigationBar: _SubmitDetails(
        bloc: bloc,
        context: context,
        selectedDate: finalSelected,
        mood: mood.toString(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                datePicker(context, finalSelected),
                SizedBox(
                  height: 10,
                ),
                moodCard(bloc),
                titleAndBody(bloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Date picker card
  Widget datePicker(BuildContext context, String finalSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: Text(
            "$finalSelected",
            textScaleFactor: 1.5,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          onTap: () => _selectDate(context),
        )
      ],
    );
  }

  ///Title and Body card
  Widget titleAndBody(Bloc bloc) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: StreamBuilder<Object>(
                  stream: bloc.titleText,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: bloc.changeTitleText,
                      decoration: InputDecoration(
                          hintText: 'Title',
                          // border: OutlineInputBorder(),
                          // icon: Icon(
                          //   FontAwesomeIcons.brain,
                          // ),
                          errorText: snapshot.error),
                      maxLength: 50,
                    );
                  }),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: StreamBuilder<Object>(
                  stream: bloc.bodyText,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: bloc.changeBodyText,
                      decoration: InputDecoration(
                        // icon: Icon(FontAwesomeIcons.penNib),
                        hintText: 'What happened...',
                        // border: OutlineInputBorder(),
                        errorText: snapshot.error,
                      ),
                      minLines: 10,
                      maxLines: 10,
                      maxLength: -1,
                    );
                  }),
            ),
          ],
        ),
      ],
    );
  }

  ///The mood card
  Widget moodCard(Bloc bloc) {
    return Column(
      children: [
        Text(
          "How would you rate this experience?",
          textScaleFactor: 1.5,
          style: TextStyle(color: Colors.green),
        ),
        Column(
          children: [
            RadioListTile(
                title: Text("Green"),
                secondary: Icon(
                  FontAwesomeIcons.smileBeam,
                  color: Colors.green,
                ),
                value: Mood.greenSun,
                groupValue: mood,
                onChanged: (Mood value) {
                  setState(() {
                    mood = value;
                  });
                }),
            RadioListTile(
                title: Text("Blue"),
                secondary: Icon(
                  FontAwesomeIcons.smile,
                  color: Colors.blue,
                ),
                value: Mood.blueSun,
                groupValue: mood,
                onChanged: (Mood value) {
                  setState(() {
                    mood = value;
                  });
                }),
            RadioListTile(
                title: Text("Red"),
                secondary: Icon(
                  FontAwesomeIcons.frown,
                  color: Colors.red,
                ),
                value: Mood.redSun,
                groupValue: mood,
                onChanged: (Mood value) {
                  setState(() {
                    mood = value;
                  });
                }),
            GestureDetector(
              child: Text(
                "learn more",
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new CircleAvatar(
                              backgroundColor: Colors.green,
                            ),
                            title: new Text('Good'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Your mental condition is great and has not been negatively affected by the experience!"),
                          ),
                          ListTile(
                            leading: new CircleAvatar(
                              backgroundColor: Colors.blue,
                            ),
                            title: new Text('Average'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Your mental condition is slightly negatively affected, you need some time on your own to recover fully!"),
                          ),
                          ListTile(
                            leading: new CircleAvatar(
                              backgroundColor: Colors.red,
                            ),
                            title: new Text('Not good'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Your mental condition has been negatively affected, the only way to recover is by sharing your experience with someone!"),
                          ),
                        ],
                      );
                    });
              },
            ),
            Divider(),
          ],
        ),
      ],
    );
  }
}

///submit the details
class _SubmitDetails extends StatelessWidget {
  _SubmitDetails({this.bloc, this.context, this.selectedDate, this.mood});
  final Bloc bloc;
  final BuildContext context;
  final String selectedDate;
  final String mood;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<Object>(
          stream: bloc.submitValid,
          builder: (context, snapshot) {
            return OutlinedButton.icon(
              icon: Icon(FontAwesomeIcons.bookReader),
              label: Text("Save Diary"),
              onPressed: snapshot.hasData ? function1 : null,
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            );
          }),
    );
  }

  function1() {
    return function2(context, selectedDate, mood);
  }

  function2(BuildContext context, String selectedDate, String mood) {
    return bloc.submit(context, selectedDate, mood);
  }
}
