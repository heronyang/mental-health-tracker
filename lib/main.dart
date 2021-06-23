import 'package:flutter/material.dart';

import 'survey.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Mental Health Tracker',
      home: MentalHealthTrackerApp(),
    ),
  );
}

class MentalHealthTrackerApp extends StatefulWidget {
  @override
  MentalHealthTrackerState createState() => MentalHealthTrackerState();
}

class MentalHealthTrackerState extends State<MentalHealthTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mental Health Tracker')),
        body: Column(
          children: <Widget>[
            Column(children: <Widget>[_buildIntro()]),
            Expanded(
              child: _buildQuestions(),
            ),
          ],
        ));
  }

  Widget _buildIntro() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Text(Survey.getIntro()),
      ),
    );
  }

  Widget _buildQuestions() {
    List<String> questions = Survey.getQuestions();
    return ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return _buildQuestion('${questions[index]}');
        });
  }

  Widget _buildQuestion(String question) {
    List<String> options = Survey.getOptions();
    return Row(
      children: [
        Expanded(child: Text(question)),
        Expanded(
            child: DropdownButton<String>(
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text("Click to answer"),
          onChanged: (String? newValue) {
            setState(() {
              // TODO
            });
          },
        )),
      ],
    );
  }
}
