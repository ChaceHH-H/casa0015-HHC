import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_reminder/drink.dart';
import 'package:water_reminder/target1.dart';
import 'clock.dart';
import 'history.dart';
import 'Water.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'clock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationHelper {
  // 使用单例模式进行初始化
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;
  NotificationHelper._internal();

  // FlutterLocalNotificationsPlugin是一个用于处理本地通知的插件，它提供了在Flutter应用程序中发送和接收本地通知的功能。
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // 初始化函数
  Future<void> initialize() async {
    // AndroidInitializationSettings是一个用于设置Android上的本地通知初始化的类
    // 使用了app_icon作为参数，这意味着在Android上，应用程序的图标将被用作本地通知的图标。
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    // 15.1是DarwinInitializationSettings，旧版本好像是IOSInitializationSettings（有些例子中就是这个）
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();
    // 初始化
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    await _notificationsPlugin.initialize(initializationSettings);
  }

//  显示通知
  Future<void> showNotification(
      {required String title, required String body}) async {
    // 安卓的通知
    // 'your channel id'：用于指定通知通道的ID。
    // 'your channel name'：用于指定通知通道的名称。
    // 'your channel description'：用于指定通知通道的描述。
    // Importance.max：用于指定通知的重要性，设置为最高级别。
    // Priority.high：用于指定通知的优先级，设置为高优先级。
    // 'ticker'：用于指定通知的提示文本，即通知出现在通知中心的文本内容。
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your.channel.id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    // ios的通知
    const String darwinNotificationCategoryPlain = 'plainCategory';
    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain, // 通知分类
    );
    // 创建跨平台通知
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);

    // 发起一个通知
    await _notificationsPlugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}




class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permissions granted
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
  }


  int currentTab = 1;
  final List<Widget> screens = [
    Water(),
    history(),
    clock(),
    target1(),
    drink1(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  final NotificationHelper _notificationHelper = NotificationHelper();
  bool clockstatus = false;
  Widget currentScreen = history();
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
    requestNotificationPermissions();
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
          _notificationHelper.showNotification(
            title: 'Hello',
            body: "It's time to drink some water",
          );
          print('Timer has finished counting down after reset.');
          getTimeState();
          resetTimer();
        });
      }

    }
  }
}
