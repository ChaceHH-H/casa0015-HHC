import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Water History'),
      ),
      body: Stack(
        children: [
          DraggableScrollableSheet(
            initialChildSize: 0.2, // 面板起始高度占屏幕的比例
            minChildSize: 0.2,  // 面板最小高度占屏幕的比例
            maxChildSize: 0.5,  // 面板最大高度占屏幕的比例
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.drag_handle),
                    Expanded(
                      child: _buildWaterHistoryList(context, scrollController),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaterHistoryList(BuildContext context, ScrollController scrollController) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTodaysWaterHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var record = snapshot.data![index];
              return Dismissible(
                key: Key(record['id']),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  FirebaseFirestore.instance.collection('water-history').doc(record['id']).delete();
                },
                confirmDismiss: (direction) => showDeleteConfirmDialog(context),
                background: Container(color: Colors.red),
                child: ListTile(
                  leading: Icon(Icons.water_drop, color: Colors.blue),
                  title: Text('${record['watervalue']} ml'),
                  trailing: Text(DateFormat('HH:mm').format(record['date'])),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No data found'));
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchTodaysWaterHistory() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

    var snapshot = await FirebaseFirestore.instance
        .collection('water-history')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "date": (doc.data() as dynamic)['date'].toDate(),
        "watervalue": doc.data()['watervalue'],
      };
    }).toList();
  }

  Future<bool> showDeleteConfirmDialog(BuildContext context) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    )) ?? false;
  }

}
