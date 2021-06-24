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
    this.scores = new List<int>.from(scores);
  }
}

class MentalHealthTrackerState extends State<MentalHealthTrackerApp>
    with SingleTickerProviderStateMixin {
  List<int> _pendingScores = [];
  List<HistoryRecord> _records = [];

  late TabController _tabController;

  static const List<Tab> tabs = <Tab>[
    Tab(icon: Icon(Icons.edit)),
    Tab(icon: Icon(Icons.trending_up)),
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabs.length);
    _resetPendingScores();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Tracker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSurveyView(),
          _buildResultView(),
        ],
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
                _buildResetButton(),
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
        onPressed: () => _commitPendingSurvey(date),
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)));
  }

  Widget _buildResetButton() {
    return ElevatedButton(
        onPressed: () => _resetPendingScores(),
        child: Text('Reset'),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)));
  }

  void _commitPendingSurvey(String date) {
    // NOTE: Flutter doesn't update the UI after setting the state here if we
    // immediately jumps to the result page.
    setState(() {
      _records.add(HistoryRecord(date, _pendingScores));
    });
    _showSubmitConfirmationDialog();
  }

  void _resetPendingScores() {
    setState(() {
      _pendingScores = List<int>.filled(Survey.getQuestionSize(), 0);
    });
  }

  Widget _buildResultView() {
    if (_records.length == 0) {
      return const Center(child: Text('No Record.'));
    }
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('Result', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      rows: List<DataRow>.generate(
          _records.length,
          (int index) => DataRow(
                cells: _buildResultCells(_records[index]),
              )),
    );
  }

  List<DataCell> _buildResultCells(HistoryRecord record) {
    int score = record.scores.reduce((a, b) => a + b);
    String comment = "Unknown";
    if (score < 20) {
      comment = "Well";
    } else if (score < 25) {
      comment = "Mild";
    } else if (score < 30) {
      comment = "Moderate";
    } else {
      comment = "Severe";
    }
    return <DataCell>[
      DataCell(Text(record.date)),
      DataCell(Text('$score')),
      DataCell(Text(comment))
    ];
  }

  Future<void> _showSubmitConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Succeed!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Go to result page new and history records.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Go'),
              onPressed: () {
                // Jumps to the result page.
                _tabController.animateTo(1);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
