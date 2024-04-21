import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class drink1 extends StatefulWidget {
  const drink1({super.key});

  @override
  State<drink1> createState() => _drinkState();
}

class _drinkState extends State<drink1> {
  FirebaseFirestore pushfirestore = FirebaseFirestore.instance;
  double drinkvalue111 = 0;
  int drinkvalue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Drink')),
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize:MainAxisSize.min,
            children: [
              Text('$drinkvalue ml',style: TextStyle(fontSize: 70)),
              Container(
                child: Row(
                  mainAxisSize:MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: LiquidCustomProgressIndicator(
                        value: drinkvalue111/400,
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        backgroundColor: Colors.grey[200],
                        direction: Axis.vertical,
                        shapePath: _buildBoatPath(),
                      ),
                    ),
                    Container(
                      height: 320,
                      child:SfSlider.vertical(
                        min: 0.0,
                        max: 400.0,
                        value: drinkvalue111,
                        interval: 50,
                        stepSize: 10,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (dynamic value) {
                          setState(() {
                            drinkvalue111 = value;
                            drinkvalue = drinkvalue111.truncate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    if(drinkvalue111 !=0){
                      pushfirestore.collection('water-history').add({
                        'watervalue': drinkvalue, // 喝水量
                        'date': FieldValue.serverTimestamp(), // 使用Firebase的服务器时间戳
                      });
                      Navigator.pop(context,drinkvalue);
                    }
                    // pushfirestore.collection('water-history').add({
                    //   'watervalue': drinkvalue, // 喝水量
                    //   'date': FieldValue.serverTimestamp(), // 使用Firebase的服务器时间戳
                    // });
                  },
                  child: Text('Add')),
            ],
          ),
        ),
        // child: Text('History Screen',style: TextStyle(fontSize: 40)),
      ),
    );
  }
  Path _buildBoatPath(){
    return Path()
      ..moveTo(15, 380)
      ..lineTo(0, 85)
      ..lineTo(185, 85)
       ..lineTo(170, 380)
      ..close();
  }
}
