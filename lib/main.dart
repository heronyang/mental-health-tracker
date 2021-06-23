import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    String today = DateFormat('yyyy-MM-dd').format(new DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('Mental Health Tracker')),
      body: Column(
        children: <Widget>[
          _buildIntro(),
          Expanded(
            child: _buildQuestions(),
          ),
          Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Today: ' + today),
                  _buildSubmitButton(),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Text(Survey.getIntro()),
      ),
    );
  }

  Widget _buildQuestions() {
    List<String> questions = Survey.getQuestions();
    return ListView.separated(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return _buildQuestion('${questions[index]}', index);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
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
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          print('submit');
        },
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)));
  }
}
