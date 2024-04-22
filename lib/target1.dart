import 'package:flutter/material.dart';

class target1 extends StatefulWidget {
  const target1({super.key});

  @override
  State<target1> createState() => _target1State();
}

class _target1State extends State<target1> {
  double ageValue= 18;
  double HValue= 18;
  double WValue= 18;
  double DValue = 1;
  double TargetgValie = 1;

  int intageValue= 18;
  int intHValue= 18;
  int intWValue= 18;
  int intDValue = 1;
  int intTargetgValie = 1;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('target1')),
      body: Center(
        child: Container(
          child: Column(
            //mainAxisSize:MainAxisSize.min,
            children: [
              Container(
                child: Text('Set your goals',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 30),
              Container(
                child: Column(
                  children: [
                    Text('How old are you = $intageValue',style: TextStyle(fontSize: 20),),

                    Slider(
                        value: ageValue,
                        min: 0,
                        max: 60,
                        divisions: 60,
                        onChanged: (double value) {
                          setState(() {
                            ageValue = value;
                            intageValue =ageValue.truncate();
                          });
                        },
                        label: ageValue.round().toString(),
                      ),

                    Text('Height ($intHValue CM)',style: TextStyle(fontSize: 20),),

                    Slider(
                        value: HValue,
                        min: 0,
                        max: 200,
                        divisions: 200,
                        onChanged: (double value) {
                          setState(() {
                            HValue = value;
                            intHValue=HValue.truncate();
                          });
                        },
                        label: HValue.round().toString(),
                      ),

                    Text('Weight ($intWValue KG)',style: TextStyle(fontSize: 20),),
                    Slider(
                        value: WValue,
                        min: 0,
                        max: 200,
                        divisions: 200,
                        onChanged: (double value) {
                          setState(() {
                            WValue = value;
                            intWValue=WValue.truncate();
                          });
                        },
                        label: WValue.round().toString(),
                      ),

                    ElevatedButton(
                      child: Text("Calculate target",style: TextStyle(fontSize: 20),),
                      onPressed: () {
                        intDValue = intWValue*40;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 30),

                    Text('$intDValue Ml',style: TextStyle(fontSize: 46,fontWeight: FontWeight.w600),),
                    Slider(
                      value: DValue,
                      min: 0,
                      max: 3000,
                      divisions: 60,
                      onChanged: (double value) {
                        setState(() {
                          DValue = value;
                          intDValue=DValue.truncate();

                        });
                      },
                      label: DValue.round().toString(),
                    ),
                    ElevatedButton(
                      child: Text("Finish",style: TextStyle(fontSize: 20),),
                      onPressed: () {
                        Navigator.pop(context,intDValue);

                      },
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
        // child: Text('History Screen',style: TextStyle(fontSize: 40)),
      ),
    );
  }

}