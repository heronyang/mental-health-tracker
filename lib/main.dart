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
  List<int> _scores = [];

  @override
  void initState() {
    setState(() {
      _scores = List<int>.filled(Survey.getQuestionSize(), 0);
    });
    super.initState();
  }

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

    Widget questionWidget = Text(question);
    Widget optionWidget = DropdownButton<int>(
      value: _scores[questionIndex],
      items: optionScores.map<DropdownMenuItem<int>>((OptionScore optionScore) {
        return DropdownMenuItem<int>(
          value: optionScore.score,
          child: Text(optionScore.option),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue == null) {
          return;
        }
        setState(() {
          _scores[questionIndex] = newValue;
        });
      },
    );

    return ListTile(title: questionWidget, trailing: optionWidget);

    /*
            Row(
      children: [
        Expanded(child: questionWidget),
        Expanded(child: optionWidget),
      ],
    );
    */
  }
}
