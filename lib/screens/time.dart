import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timimg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Time(),
          DayMount(),
        ],
      ),
    );
  }
}

class DayMount extends StatefulWidget {
  @override
  _DayMountState createState() => _DayMountState();
}

class _DayMountState extends State<DayMount> {
  final today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMM yyyy").format(today)}",
          style: TextStyle(color: Colors.deepOrange[200], fontSize: 16),
        ),
      ],
    );
  }
}

class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  final today = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String _period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    return Container(
      child: Row(
        children: [
          Text(
            '${_timeOfDay.hour}:${_timeOfDay.minute}',
            style: TextStyle(
                color: Colors.deepOrange[400],
                fontWeight: FontWeight.bold,
                fontSize: 50.0),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            _period,
            style: TextStyle(color: Colors.deepOrange[400]),
          ),
        ],
      ),
    );
  }
}
