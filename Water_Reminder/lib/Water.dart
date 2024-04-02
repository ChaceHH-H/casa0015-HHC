import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:water_reminder/clock_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  int Targetdrink = 1500;
  int Drinkingnum = 200;

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
                height: 220,
                width: 220,
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      height: 120,
                      width: 180,
                      child: Row(
                        children: [
                          Container(
                            child: Icon(FontAwesomeIcons.bottleWater,color: Colors.white,size: 50,),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Remaining',style: TextStyle(fontSize: 17,color: Colors.white),),
                              Text('ml',style: TextStyle(fontSize: 22,color: Colors.white),),
                              Text('/'+'ml',style: TextStyle(fontSize: 18,color: Colors.white),)
                            ],
                          )

                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      height: 120,
                      width: 180,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Icon(FontAwesomeIcons.clock,color: Colors.white,size: 45,),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Next Clock',style: TextStyle(fontSize: 17,color: Colors.white),),
                              Text('Time',style: TextStyle(fontSize: 22,color: Colors.white),)
                            ],
                          )

                        ],
                      ),
                    ),
                  ]
              ),
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
}
