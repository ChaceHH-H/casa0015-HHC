import 'package:flutter/material.dart';
import 'clock.dart';
import 'history.dart';
import 'Water.dart';
import 'package:water_reminder/my_flutter_app_icons.dart';

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
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Water();

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
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
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
}
