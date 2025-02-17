import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTime extends StatefulWidget {
  const CurrentTime({super.key});

  @override
  State<CurrentTime> createState() => _CurrentTimeState();
}

class _CurrentTimeState extends State<CurrentTime> {
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
    Future.delayed(Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.Hms().format(_dateTime),
      style: TextStyle(fontSize: 35),
    );
  }
}
