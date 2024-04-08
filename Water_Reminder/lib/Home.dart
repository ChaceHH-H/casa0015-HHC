import 'dart:async';

import 'package:flutter/material.dart';
import 'package:water_reminder/target1.dart';
import 'clock.dart';
import 'history.dart';
import 'Water.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clock.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    Water(),
    history(),
    clock(),
    target1(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  bool clockstatus = false;
  Widget currentScreen = Water();
  int _currentTimevalue = 30;
  String startime = '1';
  String endtime = '1';
  int starthour = 1;
  int endhour = 1;

  void initState() {
    super.initState();
    getSwitchValues();
    getTimepicker1();
    getTimepicker2();
  }
  getSwitchValues() async {

    getSwitchState();
    getTimeState();
    setState(() {});


  }
  void getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clockstatus = prefs.getBool("switchState")!;
    print('switch$clockstatus');
    if(clockstatus){
      resetTimer();

    }
  }
  void getTimeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTimevalue = prefs.getInt("TimeState")!;
    print('switch$_currentTimevalue');
  }

  void getTimepicker1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    startime = prefs.getString("Timepicker1")!;
    print('$startime');
    starthour = int.parse(startime.split(":")[0]);
    String amPm = startime.split(" ")[1];
    if (amPm == "PM" && starthour < 12) {
      starthour += 12;
    }
    else if (amPm == "AM" && starthour == 12) {
      starthour = 0;
    }
    print(starthour);
  }
  void getTimepicker2() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    endtime = prefs.getString("Timepicker2")!;
    print('$endtime');
    endhour = int.parse(endtime.split(":")[0]);
    String amPm = endtime.split(" ")[1];
    if (amPm == "PM" && endhour < 12) {
      endhour += 12;
    }
    else if (amPm == "AM" && endhour == 12) {
      endhour = 0;
    }
    print(endhour);
  }



  late Timer _timer = Timer(Duration(minutes: _currentTimevalue), () {
    // This block of code will be executed when the timer finishes.
    print('Timer has finished counting down.');
  });




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton.large(
        child: Icon(
          Icons.water_drop,
          color: currentTab == 0 ? Colors.blue : Colors.grey,
          size: 50,
        ),
        onPressed: (){
          setState(() {
            currentScreen = Water();
            currentTab=0;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
        //notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              height: 80,
              onPressed: (){
                setState(() {
                  currentScreen = history();
                  currentTab=1;
                });
              },

              child: Icon(

                Icons.align_vertical_bottom,
                color: currentTab == 1 ? Colors.blue : Colors.grey,
                size: 40.0
              ),
            ),
            MaterialButton(
              height: 80,
              onPressed: (){
                setState(() {
                  currentScreen = clock();
                  currentTab=2;
                });
              },
              child: Icon(
                  Icons.access_alarm,
                color: currentTab == 2 ? Colors.blue : Colors.grey,
                size: 40.0
              ),
            ),
          ],
        ),
      ),
    );
  }
  void resetTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    if(clockstatus){
      int now = TimeOfDay.now().hour;
      if(now >=starthour && now<=endhour){
        print('clock');
        //resetTimer();
        _timer = Timer(Duration(minutes: _currentTimevalue), () {
          // Code to execute after the timer resets and finishes counting down.
          print('Timer has finished counting down after reset.');
          getTimeState();
          resetTimer();
        });
      }

    }
  }
}
