import 'package:flutter/material.dart';

class clock extends StatefulWidget {
  const clock({super.key});

  @override
  State<clock> createState() => _clockState();
}

class _clockState extends State<clock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clock')),
      body: Center(
        child: Text('Clock Screen',style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
