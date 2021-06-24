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

class HistoryRecord {
  String date = "";
  List<int> scores = [];
  HistoryRecord(String date, List<int> scores) {
    this.date = date;
    this.scores = scores;
  }
}

class MentalHealthTrackerState extends State<MentalHealthTrackerApp> {
  List<int> _pendingScores = [];
  List<HistoryRecord> _records = [];

  @override
  void initState() {
    _resetPendingScores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.edit)),
                Tab(icon: Icon(Icons.trending_up)),
              ],
            ),
            title: Text('Mental Health Tracker'),
          ),
          body: TabBarView(
            children: [
              _buildSurveyView(),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurveyView() {
    String today = DateFormat('yyyy-MM-dd').format(new DateTime.now());
    return Column(
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
                _buildSubmitButton(today),
              ],
            )),
      ],
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
      value: _pendingScores[questionIndex],
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
          _pendingScores[questionIndex] = newValue;
        });
      },
    );

    return ListTile(title: questionWidget, trailing: optionWidget);
  }

  Widget _buildSubmitButton(String date) {
    return ElevatedButton(
        onPressed: () {
          _commitPendingSurvey(date);
        },
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)));
  }

  void _commitPendingSurvey(String date) {
    _records.add(HistoryRecord(date, _pendingScores));
    _resetPendingScores();
  }

  void _resetPendingScores() {
    setState(() {
      _pendingScores = List<int>.filled(Survey.getQuestionSize(), 0);
    });
  }
}
