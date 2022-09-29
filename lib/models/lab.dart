import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab_availability_checker/models/module.dart';
import 'package:lab_availability_checker/models/removal_chance.dart';
import 'package:lab_availability_checker/models/room.dart';

class Lab {
  final int? id;
  final Module module;
  final int day;
  final String startTime;
  final String endTime;
  final RemovalChance? removalChance;
  final List<String> rooms;

  Lab(
      {this.id,
      required this.module,
      required this.day,
      required this.startTime,
      required this.endTime,
      required this.removalChance,
      required this.rooms});

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
        id: json['id'],
        module: Module.fromJson(json['module']),
        day: json['day'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        removalChance: json['removalChance'] == null
            ? null
            : RemovalChance.values
                .singleWhere((e) => e.toString() == "RemovalChance." + json['removalChance']),
        rooms: (json['rooms'] as List).map((e) => e.toString()).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module.id,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'removalChance': removalChance?.name,
      'room': rooms.first
    };
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
