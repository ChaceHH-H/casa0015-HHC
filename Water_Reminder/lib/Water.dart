import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:water_reminder/clock.dart';
import 'package:water_reminder/clock_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:water_reminder/history.dart';
import 'package:water_reminder/target1.dart';
import 'package:water_reminder/drink.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {

  int  Targetdrink = 1500;
  int todayvalue = 0;
  int Drinkingnum = 200;
  int percentage = 0;
  @override
  void initState() {

    super.initState();
    Cvalue();
    compareDateWithToday();
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:(){
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:(){
        Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (_) {
        //   return target1();
        // }));
        _navigateAndDisplaySelection(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to reset your Drinking Goal?"),
      //content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void savetarget(int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("target", value);
    print('target Value saved $value');
    //return prefs.setInt("TimeState", value);
  }
  void gettarget() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Targetdrink = prefs.getInt("target")!;
    });

    print('target$Targetdrink');
  }

  void savetoday(int value,) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("todayvalue", value);
    print('target Value saved $value');
  }
  Future<void> saveDate() async {
    DateTime time1111 = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedDate', time1111.millisecondsSinceEpoch);
  }
  Future<DateTime?> loadDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? milliseconds = prefs.getInt('savedDate');
    if (milliseconds != null) {
      return DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }
    return null; // 如果没有找到保存的日期，则返回null
  }

  Future<void> compareDateWithToday() async {
    DateTime? savedDate = await loadDate();

    if (savedDate != null) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      // 仅比较日期部分
      savedDate = DateTime(savedDate.year, savedDate.month, savedDate.day);

      if (savedDate.isBefore(today)) {
        print("The saved date is before today.");
        Targetdrink = 0;
        savetarget(Targetdrink);
      } else if (savedDate.isAtSameMomentAs(today)) {
        print("The saved date is today.");
        gettarget();
      }
    } else {
      print("No date saved.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.blue[400],
      appBar: AppBar(
        title: const Text('Water'),
      ),
        body:
        Center(
          child: Container(
            child: Column(
              //mainAxisSize:MainAxisSize.min,
              children: [
                SizedBox(height: 50),
                Container(
                  alignment: Alignment.center,
                  height: 300,
                  width: 300,
                  child: LiquidCircularProgressIndicator(
                    value: todayvalue/Targetdrink,
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                    backgroundColor: Colors.blue[800],
                    borderColor: Colors.black54,
                    borderWidth: 0.0,
                    direction: Axis.vertical,
                    center: Text('$percentage%',style: TextStyle(fontSize: 60,color: Colors.white,fontWeight: FontWeight.w500),),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                    mainAxisSize:MainAxisSize.min ,
                    children:[
                      InkWell(
                        onTap: () {
                          showAlertDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[400],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          height: 120,
                          width: 350,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(FontAwesomeIcons.bottleWater,color: Colors.white,size: 80,),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Target Drink',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w500),),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text('ml',style: TextStyle(fontSize: 25,color: Colors.white),),
                                        Text('/'+'$Targetdrink ml',style: TextStyle(fontSize: 20,color: Colors.white),)
                                      ],
                                    ),
                                  ),

                                ],
                              )

                            ],
                          ),
                        ),
                      ),


                    ]
                ),
                ElevatedButton(
                    onPressed: (){
                      _adddrink(context);
                    },
                    child: Text('Add')),
                SizedBox(height: 30),
                Row(
                  mainAxisSize:MainAxisSize.min ,
                  children: [

                  ],
                ),
              ],
            ),
          ),
        ),


    );
  }


  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const target1()),
    );
    setState(() {
      Targetdrink = result;
      print('$Targetdrink');
      Cvalue();
      saveDate();
    });
    savetarget(Targetdrink);
    if (!context.mounted) return;

  }
  Future<void> _adddrink(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const drink1()),
    );
    setState(() {
      Drinkingnum = result;
      print('DRINK $Drinkingnum');
      Cvalue();
    });

    if (!context.mounted) return;

  }

  void Cvalue(){
    percentage = ((todayvalue/Targetdrink)*100).truncate();
  }


  //////////////////////
  Future<List<Map<String, dynamic>>> fetchTodaysWaterHistory() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 获取今天的日期范围
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime tomorrowStart = DateTime(now.year, now.month, now.day + 1);

    // 转换为Timestamp
    Timestamp startTimestamp = Timestamp.fromDate(todayStart);
    Timestamp endTimestamp = Timestamp.fromDate(tomorrowStart);

    QuerySnapshot querySnapshot = await firestore
        .collection('water-history')
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThan: endTimestamp)
        .orderBy('date', descending: true) // 降序排序
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        "id": doc.id, // 包含文档ID
        "date": (doc.data() as Map<String, dynamic>)['date'],
        "watervalue": (doc.data() as Map<String, dynamic>)['watervalue'],
      };
    }).toList();
  }

  Future<bool> showDeleteConfirmDialog(BuildContext context, String docId) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // 用户点击取消，返回false
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true); // 用户点击删除，返回true
              },
            ),
          ],
        );
      },
    ) ?? false; // 如果点击对话框外部，返回false
  }







}
