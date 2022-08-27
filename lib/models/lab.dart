import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lab_availability_checker/models/module.dart';
import 'package:lab_availability_checker/models/room.dart';

class Lab {
  final Module module;
  final int day;
  final String startTime;
  final String endTime;
  final RemovalChance? removalChance;
  final List<Room> rooms;

  Lab(
      {required this.module,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.removalChance,
      required this.rooms});

  factory Lab.fromJson(Map<String, dynamic> json) {
    print("Extracting lab");
    print(json);
    try {
      var t = Lab(
          module: Module.fromJson(json['module']),
          day: json['day'],
          startTime: json['startTime'],
          endTime: json['endTime'],
          removalChance: json['removalChance'] == null
              ? null
              : RemovalChance.values
                  .singleWhere((e) => e.toString() == "RemovalChance." + json['removalChance']),
          rooms: []);
    } catch (on, stackTrace) {
      print(stackTrace);
    }
    return Lab(
        module: Module.fromJson(json['module']),
        day: json['day'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        removalChance: json['removalChance'] == null
            ? null
            : RemovalChance.values
                .singleWhere((e) => e.toString() == "RemovalChance." + json['removalChance']),
        // rooms: json['rooms'].map<Room>((json) => Room.fromJson(json)).toList()
        rooms: []);
  }

  String getStartTime() {
    return "${startTime.substring(0, 2)}:${startTime.substring(2, 4)}";
  }

  String getEndTime() {
    return "${endTime.substring(0, 2)}:${endTime.substring(2, 4)}";
  }

  IconData getIcon() {
    switch (removalChance) {
      case null:
      case RemovalChance.low:
        return Icons.person;
      case RemovalChance.medium:
        return Icons.people;
      case RemovalChance.high:
      case RemovalChance.definite:
        return Icons.groups;
    }
  }
}

enum RemovalChance {
  low,
  medium,
  high,
  definite,
}

extension RemovalChanceFromString on RemovalChance {
  RemovalChance? toEnum(String value) {
    switch (value) {
      case "low":
        return RemovalChance.low;
      case "medium":
        return RemovalChance.medium;
      case "high":
        return RemovalChance.high;
      case "definite":
        return RemovalChance.definite;
      default:
        return null;
    }
  }
}
