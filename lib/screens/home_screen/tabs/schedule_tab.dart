import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleTab extends StatefulWidget {
  final dayIndex;

  ScheduleTab({this.dayIndex});

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  @override
  Widget build(BuildContext context) {
    return widget.dayIndex > 2
        ? Container(
            color: Colors.green,
          )
        : Container(
            color: Colors.grey,
          );
  }
}
