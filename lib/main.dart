import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localizations.dart';
import 'survey.dart';

void main() {
  runApp(
    MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      home: MindTrendApp(),
      theme: new ThemeData(primarySwatch: Colors.teal),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('zh', ''),
      ],
    ),
  );
}

class MindTrendApp extends StatefulWidget {
  MindTrendApp({Key? key}) : super(key: key);
  @override
  MindTrendState createState() => MindTrendState();
}

class HistoryRecord {
  String timestamp = "";
  List<int> scores = [];
  HistoryRecord(String timestamp, List<int> scores) {
    this.timestamp = timestamp;
    this.scores = new List<int>.from(scores);
  }
}

class MindTrendState extends State<MindTrendApp>
    with SingleTickerProviderStateMixin {
  List<int> _pendingScores = [];
  List<HistoryRecord> _records = [];
  final String storageKey = 'records';
  final int numberOfQuestions = 10; // NOTE: Always sync with survey.dart.

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
    _loadRecords();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _processBuildCompleted(context));
  }

  void _processBuildCompleted(BuildContext context) {
    _showWelcomeDialog();
  }

  void _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _records = _decodeRecords(prefs.getString(storageKey) ?? "");
    });
  }

  void _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString(storageKey, _encodeRecords(_records));
    });
  }

  List<HistoryRecord> _decodeRecords(String encodedRecords) {
    List<HistoryRecord> records = [];
    for (var encodedRecord in encodedRecords.split('.')) {
      if (encodedRecord.length == 0) {
        continue;
      }
      var chunks = encodedRecord.split(',');
      var timestamp = chunks[0];
      var encodedScores = chunks[1];
      List<int> scores = [];
      encodedScores.runes.forEach((int rune) {
        scores.add(int.parse(new String.fromCharCode(rune)));
      });
      records.add(HistoryRecord(timestamp, scores));
    }
    return records;
  }

  String _encodeRecords(List<HistoryRecord> records) {
    // Custom format: <timestamp>,<scores>.<timestamp>:...
    var buffer = new StringBuffer();
    for (var record in records) {
      buffer.write(record.timestamp);
      buffer.write(",");
      for (var score in record.scores) {
        buffer.write("$score");
      }
      buffer.write(".");
    }
    return buffer.toString();
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
        title: Text(AppLocalizations.of(context).title),
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
    return Column(
      children: <Widget>[
        _buildIntro(),
        Expanded(
          child: _buildQuestions(),
        ),
      ],
    );
  }

  Widget _buildIntro() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        color: Colors.teal.shade200,
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Text(AppLocalizations.of(context).survey.getIntro()),
      ),
    );
  }

  Widget _buildQuestions() {
    List<String> questions = AppLocalizations.of(context).survey.getQuestions();
    return ListView.separated(
      itemCount: questions.length + 1, // Submit button is the last row.
      itemBuilder: (context, index) {
        if (index == questions.length) {
          return _buildSubmitButton();
        }
        return _buildQuestion('${questions[index]}', index);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildQuestion(String question, int questionIndex) {
    List<OptionScore> optionScores =
        AppLocalizations.of(context).survey.getOptionScores();

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

  Widget _buildSubmitButton() {
    String timestamp =
        DateFormat('yyyy-MM-dd HH:mm').format(new DateTime.now());
    return ElevatedButton.icon(
        onPressed: () => _commitPendingSurvey(timestamp),
        icon: Icon(
          Icons.send_rounded,
        ),
        label: Text(AppLocalizations.of(context).button_submit),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)));
  }

  void _commitPendingSurvey(String timestamp) {
    if (_pendingScores.contains(0)) {
      _showMissingResponseDialog();
      return;
    }
    // NOTE: Flutter doesn't update the UI after setting the state here if we
    // immediately jumps to the result page.
    setState(() {
      _records.add(HistoryRecord(timestamp, _pendingScores));
    });
    _saveRecords();
    _showSubmitConfirmationDialog();
  }

  void _resetPendingScores() {
    setState(() {
      _pendingScores = List<int>.filled(numberOfQuestions, 0);
    });
  }

  Widget _buildResultView() {
    if (_records.length == 0) {
      return const Center(child: Text('No Record.'));
    }
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(AppLocalizations.of(context).table_head_time,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).table_head_score,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text(AppLocalizations.of(context).table_head_result,
              style: TextStyle(fontWeight: FontWeight.bold)),
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
    Widget comment = Icon(Icons.error_outline_rounded);
    if (score < 20) {
      // "Well".
      comment =
          Icon(Icons.sentiment_satisfied_alt_rounded, color: Colors.green);
    } else if (score < 25) {
      // "Mild"
      comment = Icon(Icons.sentiment_neutral_rounded, color: Colors.yellow);
    } else if (score < 30) {
      // "Moderate;
      comment = Icon(Icons.sentiment_dissatisfied_rounded, color: Colors.amber);
    } else {
      // "Severe"
      comment = Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
    }
    return <DataCell>[
      DataCell(Text(record.timestamp)),
      DataCell(Text('$score')),
      DataCell(comment),
    ];
  }

  Future<void> _showSubmitConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).dialog_succeed_title),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(AppLocalizations.of(context).dialog_succeed_content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).dialog_succeed_button),
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

  Future<void> _showMissingResponseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).dialog_failed_empty_title),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(AppLocalizations.of(context).dialog_failed_empty_content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).dialog_succeed_button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showWelcomeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).dialog_welcome_title),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(AppLocalizations.of(context).dialog_welcome_content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).dialog_succeed_button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
