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
    final DateTime? picked = await showDatePicker(
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
            icon: Icon(Icons.info_outline_rounded),
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
              fontWeight: FontWeight.bold,
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
                          border: OutlineInputBorder(),
                          icon: Icon(
                            FontAwesomeIcons.bookmark,
                          ),
                          errorText: snapshot.error.toString()),
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
                        border: OutlineInputBorder(),
                        errorText: snapshot.error.toString(),
                      ),
                      minLines: 1,
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
        Divider(
          color: Colors.blueGrey,
          thickness: 5,
        ),
        Column(
          children: [
            RadioListTile(
                title: Text(
                  "Green",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                secondary: Icon(
                  FontAwesomeIcons.circle,
                  color: Colors.green,
                ),
                value: Mood.greenSun,
                groupValue: mood,
                onChanged: (value) {
                  setState(() {
                    mood = value as Mood;
                  });
                }),
            RadioListTile(
                title: Text(
                  "Blue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                secondary: Icon(
                  FontAwesomeIcons.faceSmile,
                  color: Colors.blue,
                ),
                value: Mood.blueSun,
                groupValue: mood,
                onChanged: (value) {
                  setState(() {
                    mood = value as Mood;
                  });
                }),
            RadioListTile(
                title: Text(
                  "Red",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                secondary: Icon(
                  FontAwesomeIcons.circle,
                  color: Colors.red,
                ),
                value: Mood.redSun,
                groupValue: mood,
                onChanged: (value) {
                  setState(() {
                    mood = value as Mood;
                  });
                }),
            Divider(
              color: Colors.blueGrey,
              thickness: 5,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ),
      ],
    );
  }
}

///submit the details
class _SubmitDetails extends StatelessWidget {
  _SubmitDetails(
      {required this.bloc,
      required this.context,
      required this.selectedDate,
      required this.mood});
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
              icon: Icon(FontAwesomeIcons.book),
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
