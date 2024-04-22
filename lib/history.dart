import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

enum ViewMode { day, week, month }


class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  DateTime selectedDate = DateTime.now();
  ViewMode viewMode = ViewMode.day;
  int totalIntake = 0;
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchDataForSelectedDate();
  }

  void adjustDate(int addValue) {
    setState(() {
      if (viewMode == ViewMode.day) {
        selectedDate = selectedDate.add(Duration(days: addValue));
      } else if (viewMode == ViewMode.week) {
        selectedDate = selectedDate.add(Duration(days: 7 * addValue));
      } else if (viewMode == ViewMode.month) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month + addValue, selectedDate.day);
      }
      fetchDataForSelectedDate();
    });
  }

  void fetchDataForSelectedDate() async {
    DateTime start;
    DateTime end;

    if (viewMode == ViewMode.day) {
      start = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      end = start.add(Duration(days: 1));
    } else if (viewMode == ViewMode.week) {
      start = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
      end = start.add(Duration(days: 7));
    } else {
      start = DateTime(selectedDate.year, selectedDate.month, 1);
      end = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    }

    var snapshot = await FirebaseFirestore.instance
        .collection('water-history')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date')
        .get();

    totalIntake = 0;
    List<FlSpot> newChartData = [];
    int index = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data();
      totalIntake += (data['watervalue'] as num).toInt();
      DateTime date = (data['date'] as Timestamp).toDate();
      double x = index.toDouble();
      double y = (data['watervalue'] as num).toDouble();
      newChartData.add(FlSpot(x, y));
      index++;
    }

    setState(() {
      chartData = newChartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        children: [
          ToggleButtons(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Day')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Week')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Month')),
            ],
            isSelected: [
              viewMode == ViewMode.day,
              viewMode == ViewMode.week,
              viewMode == ViewMode.month,
            ],
            onPressed: (index) {
              setState(() {
                viewMode = ViewMode.values[index];
                fetchDataForSelectedDate();
              });
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () => adjustDate(-1),
                ),
                Text(
                  viewMode == ViewMode.day
                      ? DateFormat('yyyy-MM-dd').format(selectedDate)
                      : (viewMode == ViewMode.week
                      ? 'Week of ${DateFormat('MMMd').format(selectedDate)}'
                      : DateFormat('MMMM yyyy').format(selectedDate)),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () => adjustDate(1),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(spots: chartData),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chartData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${chartData[index].y.toInt()} ml'),
                  subtitle: Text('Index ${chartData[index].x.toInt()}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}