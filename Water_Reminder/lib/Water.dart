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


class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  int  Targetdrink = 1500;
  int Drinkingnum = 200;
  @override
  void initState() {

    super.initState();
    gettarget();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.blue[500],
      appBar: AppBar(title: const Text('Water')),
      body:
      Center(
        child: Container(
          child: Column(
            mainAxisSize:MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                height: 300,
                width: 300,
                child: LiquidCircularProgressIndicator(
                  value: 0.4,
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  backgroundColor: Colors.blue[800],
                  borderColor: Colors.black54,
                  borderWidth: 0.0,
                  direction: Axis.vertical,
                  center: Text("Loading......"),
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    height: 120,
                    width: 180,
                  )
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
    });

    if (!context.mounted) return;

  }
}
