import 'package:flutter/material.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: Center(
        child: Text('History Screen',style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
