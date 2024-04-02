import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class clock extends StatefulWidget {
  const clock({super.key});

  @override
  State<clock> createState() => _clockState();
}

class _clockState extends State<clock> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clock')),
      body: Center(
        child: Column(
          //mainAxisSize:MainAxisSize.min,

          children: [

            Container(

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
                    value: status,
                    borderRadius: 30,
                    //toggleSize: 50,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        status = val;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
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
                    child: Text('00:00---00:00',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w400)),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text('Interval Timer',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
            ),
            Container(
              
            ),
          ],
        ),
      ),
    );
  }
}
