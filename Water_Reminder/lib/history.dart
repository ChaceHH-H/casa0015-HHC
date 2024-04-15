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
  int totalIntake = 0; // 假设的总摄入量
  List<Map<String, dynamic>> intakeList = []; // 用于存储水量记录

  @override
  void initState() {
    super.initState();
    fetchDataForSelectedDate(); // 初始加载今天的数据
  }

  // 从Firestore获取选定日期的水量记录
  void fetchDataForSelectedDate() async {
    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

    var snapshot = await FirebaseFirestore.instance
        .collection('water-history')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    totalIntake = 0; // 重置总摄入量
    intakeList = snapshot.docs.map((doc) {
      var data = doc.data();
      totalIntake += (data['watervalue'] as num).toInt();
      return {
        "time": (data['date'] as Timestamp).toDate(),
        "amount": data['watervalue'],
      };
    }).toList();

    setState(() {}); // 刷新UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('水量记录'),
      ),
      body: Column(
        children: [
          // 顶部的天/周/月切换栏
          // ...

          // 日期选择器
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1);
                      fetchDataForSelectedDate();
                    });
                  },
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
                      fetchDataForSelectedDate();
                    });
                  },
                ),
              ],
            ),
          ),

          // 水量记录列表
          Expanded(
            child: ListView.builder(
              itemCount: intakeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${intakeList[index]['amount']} ml'),
                  subtitle: Text(DateFormat('HH:mm').format(intakeList[index]['time'])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}