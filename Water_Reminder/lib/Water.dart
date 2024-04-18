import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    //compareDateWithToday();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.blue[400],
      appBar: AppBar(
        title: const Text('Water'),
      ),
        body:
        Stack(
          children:[Container(
            child: Column(
              children: [
                SizedBox(height: 50),
                Container(
                  height: 250,
                  width: 250,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        Text('$todayvalue ml',style: TextStyle(fontSize: 25,color: Colors.white),),
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
                // ElevatedButton(
                //     onPressed: (){
                //       _adddrink(context);
                //     },
                //     child: Text('Add Record')
                // ),
                ElevatedButton.icon(
                    onPressed: () {
                      _adddrink(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                        "Add Record"
                    )
                ),



              ],
            ),
          ),
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
            ]
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


  ////////////////////
  Widget _buildWaterHistoryList(BuildContext context, ScrollController scrollController) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('water-history')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No water intake records found for today.'));
        }

        int newTodayValue = snapshot.data!.docs.fold<int>(0, (sum, doc) {
          var data = doc.data() as Map<String, dynamic>;
          return sum + (data['watervalue'] as num).toInt();
        });

        // Schedule a callback to update the state after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (newTodayValue != todayvalue) {
            setState(() {
              todayvalue = newTodayValue;
              percentage = ((todayvalue / Targetdrink) * 100).truncate(); // Update the percentage as well
            });
          }
        });

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Total water intake today: $todayvalue ml",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  var data = doc.data() as Map<String, dynamic>;
                  return Dismissible(
                    key: Key(doc.id),
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) => showDeleteConfirmDialog(context),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance.collection('water-history').doc(doc.id).delete();
                    },
                    child: ListTile(
                      leading: Icon(Icons.water_drop, color: Colors.blue),
                      title: Text('${data['watervalue']} ml'),
                      trailing: Text(DateFormat('HH:mm').format((data['date'] as Timestamp).toDate())),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
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
