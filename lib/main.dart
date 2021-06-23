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
  List<String> responses = [];

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
          return _buildQuestion('${questions[index]}', index);
        });
  }

  Widget _buildQuestion(String question, int questionIndex) {
    List<OptionScore> optionScores = Survey.getOptionScores();
    return Row(
      children: [
        Expanded(child: Text(question)),
        Expanded(
            child: DropdownButton<int>(
          items: optionScores
              .map<DropdownMenuItem<int>>((OptionScore optionScore) {
            return DropdownMenuItem<int>(
              value: optionScore.score,
              child: Text(optionScore.option),
            );
          }).toList(),
          hint: Text("Click to answer"),
          onChanged: (int? newValue) {
            print(newValue);
          },
        )),
      ],
    );
  }
}
