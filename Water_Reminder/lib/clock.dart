import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder/Home.dart';


class Timevalue{
  final int _key;
  final String _value;
  Timevalue(this._key,this._value);
}

class clock extends StatefulWidget {
  const clock({super.key});

  @override
  State<clock> createState() => _clockState();
}

class _clockState extends State<clock> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
  TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));

  String startime = '1';
  String endtime = '1';


  bool clockstatus = false;
  int _currentTimevalue = 30;
  String Timeresult = 'time';
  final _button0ptions = [
    Timevalue(30, '00:30'),
    Timevalue(60, '01:00'),
    Timevalue(180, '01:30'),
    Timevalue(240, '02:00'),
    Timevalue(300, '02:30'),
    Timevalue(360, '03:00'),
    Timevalue(420, '03:30'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSwitchValues();
  }
  getSwitchValues() async {
    clockstatus = await getSwitchState();
    getTimeState();
    getTimepicker1();
    getTimepicker2();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    print('Switch Value saved $value');
    return prefs.setBool("switchState", value);
  }
  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool clockstatus = prefs.getBool("switchState") ?? false;
    print(clockstatus);
    return clockstatus;
  }

  void saveTimeState(int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("TimeState", value);
    print('Switch Value saved $value');
    //return prefs.setInt("TimeState", value);
  }
  void getTimeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTimevalue = prefs.getInt("TimeState")!;
  }

  void saveTimepicker1(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Timepicker1", value);
    print('Switch Value saved $value');
  }
  void saveTimepicker2(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Timepicker2", value);
    print('Switch Value saved $value');
  }
  void getTimepicker1() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    startime = prefs.getString("Timepicker1")!;
  }
  void getTimepicker2() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    endtime = prefs.getString("Timepicker2")!;
    print('$endtime');
    int hour = int.parse(endtime.split(":")[0]);
    String amPm = endtime.split(" ")[1];
    if (amPm == "PM" && hour < 12) {
      hour += 12;
    }
    else if (amPm == "AM" && hour == 12) {
      hour = 0;
    }
    print(hour);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clock')),
      body: Center(
        child: Column(
          mainAxisSize:MainAxisSize.min,

          children: [

            Container(
              //margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Water clock',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600)),
                  SizedBox(width: 30),
                  FlutterSwitch(
                    activeColor: Colors.blue,
                    width: 70,
                    height: 35,
                    valueFontSize: 18,
                    value: clockstatus,
                    borderRadius: 30,
                    //toggleSize: 50,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        clockstatus = val;
                        saveSwitchState(val);

                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              height: 55,
              width: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('Sleep',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    // child:ElevatedButton(
                    //   onPressed: () async {
                    //     TimeRange? result = await showTimeRangePicker(
                    //       context: context,
                    //     );
                    //
                    //     if (kDebugMode) {
                    //       print("result $result");
                    //       //Timeresult = result as String;
                    //     }
                    //   },
                    //   child: Text("Start: ${_startTime.format(context)}"),
                    // ),
                    child:ElevatedButton(
                      onPressed: () {
                        showTimeRangePicker(
                          context: context,
                          start: const TimeOfDay(hour: 10, minute: 0),
                          onStartChange: (start) {
                            if (kDebugMode) {
                              print("start time $start");
                              _startTime = start;
                              startime = _startTime.format(context);
                              setState(() {});
                              saveTimepicker1(startime);
                            }
                          },
                          onEndChange: (end) {
                            if (kDebugMode) {
                              print("end time $end");
                              _endTime = end;
                              endtime = _endTime.format(context);
                              setState(() {});
                              saveTimepicker2(endtime);
                              print("new time $endtime");
                            }
                          },
                          interval: const Duration(hours: 1),
                          minDuration: const Duration(hours: 1),
                          use24HourFormat: false,
                          padding: 30,
                          strokeWidth: 20,
                          handlerRadius: 14,
                          strokeColor: Colors.orange,
                          handlerColor: Colors.orange[700],
                          selectedColor: Colors.amber,
                          backgroundColor: Colors.black.withOpacity(0.3),
                          ticks: 12,
                          ticksColor: Colors.white,
                          snap: true,
                          labels: [
                            "12 am",
                            "3 am",
                            "6 am",
                            "9 am",
                            "12 pm",
                            "3 pm",
                            "6 pm",
                            "9 pm"
                          ].asMap().entries.map((e) {
                            return ClockLabel.fromIndex(
                                idx: e.key, length: 8, text: e.value);
                          }).toList(),
                          labelOffset: -30,
                          labelStyle: const TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          timeTextStyle: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          activeTimeTextStyle: const TextStyle(
                              color: Colors.orange,
                              fontSize: 26,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        );

                      },
                      child: Text("$startime"+" : $endtime"),

                    ),

                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text('Interval Timer',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              height: 400,
              width: 330,

              child: ListView(

                padding: EdgeInsets.all(8),
                children: _button0ptions.map((Timevalue) => RadioListTile<int>(
                  groupValue: _currentTimevalue,
                  title: Text(Timevalue._value),
                  value: Timevalue._key,
                  onChanged: (val){
                    setState(() {
                      debugPrint('VAL = $val');
                      _currentTimevalue = val!;
                      saveTimeState(val);
                      print('tate is $_currentTimevalue');
                    });
                  },
                  )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
