import 'package:flutter/material.dart';

void main() {
  runApp(MentalHealthTrackerApp());
}

class MentalHealthTrackerApp extends StatelessWidget {
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
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Question',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Response',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(
                          'About how often did you feel tired out for no good reason?')),
                      DataCell(Text('-')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('About how often did you feel nervous?')),
                      DataCell(Text('-')),
                    ],
                  ),
                ],
              ),
              Icon(Icons.trending_up),
            ],
          ),
        ),
      ),
    );
  }
}
