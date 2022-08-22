import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'firebase_options.dart';

class LabStatus extends StatefulWidget {
  const LabStatus({Key? key, required this.room}) : super(key: key);

  final String room;

  @override
  State<LabStatus> createState() => LabStatusState();
}

class LabStatusState extends State<LabStatus> {
  String _room_status = "Loading...";

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            child: Center(
                child: Column(
      children: <Widget>[Text("${widget.room} is"), Text(_room_status)],
    ))));
  }

  Future<String>? setRoomStatus() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final event = await ref.once(DatabaseEventType.value);
    final rooms = event.snapshot.value as Map<dynamic, dynamic>;
    List<Lab> labs = [];

    rooms.forEach((key, value) {});

    return "Unknown";
  }
}
