import 'package:flutter/material.dart';
import 'package:lab_availability_checker/models/lab.dart';

class Room {
  final String name;
  final RoomSize size;
  final RoomType type;
  final Popularity? popularity;
  final RemovalChance? removalChance;
  final int? reportCount;
  final Lab? currentLab;
  final Lab? nextLab;

  Room({
    required this.name,
    required this.size,
    required this.type,
    this.popularity,
    this.removalChance,
    this.reportCount,
    this.currentLab,
    this.nextLab,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    Room? t;
    print(json);
    try {
      t = Room(
          name: json['name'],
          reportCount: json['reportCount'],
          currentLab: json['currentLab'] != null ? Lab.fromJson(json['currentLab']) : null,
          nextLab: json['nextLab'] != null ? Lab.fromJson(json['nextLab']) : null,
          size: RoomSize.values.firstWhere((e) => e.toString() == "RoomSize." + json['size']),
          type: RoomType.values.firstWhere((e) => e.toString() == "RoomType." + json['type']),
          popularity: json['popularity'] == null
              ? null
              : Popularity.values
                  .firstWhere((e) => e.toString() == "Popularity." + json['popularity']),
          removalChance: json['removalChance'] == null
              ? null
              : RemovalChance.values
                  .singleWhere((e) => e.toString() == "RemovalChance." + json['removalChance']));
    } catch (on, stackTrace) {
      print(stackTrace);
    }
    return t!;
  }

  String getStatusString() {
    if (type == RoomType.pod) {
      print("Pod with popularity: ${popularity} and removal: ${removalChance}");
      if ((popularity ?? Popularity.empty) == Popularity.empty &&
          (removalChance ?? RemovalChance.low) == RemovalChance.low) {
        return "Free";
      }
      return "In use";
    }

    if (popularity == Popularity.very_busy || removalChance == RemovalChance.definite) {
      return "Very busy";
    }
    if ((popularity?.index ?? Popularity.empty.index) >= Popularity.busy.index ||
        removalChance == RemovalChance.high) {
      return "Busy";
    }

    if ((popularity ?? Popularity.empty).index >= Popularity.medium.index) {
      return "Fairly busy";
    }

    return "Quiet";
  }

  Color getStatusColour() {
    if (popularity == Popularity.very_busy || removalChance == RemovalChance.definite) {
      return const Color(0xFF9D0000);
    }
    if ((popularity?.index ?? Popularity.empty.index) >= Popularity.busy.index ||
        removalChance == RemovalChance.high) {
      return Colors.red;
    }

    if ((popularity ?? Popularity.empty).index >= Popularity.medium.index) {
      return const Color(0xFFF1C21B);
    }

    return Colors.green;
  }
}

enum RoomSize { small, medium, large }

extension RoomSizeString on RoomSize {
  RoomSize? toEnum(String value) {
    switch (value) {
      case "small":
        return RoomSize.small;
      case "medium":
        return RoomSize.medium;
      case "large":
        return RoomSize.large;
      default:
        return null;
    }
  }
}

enum RoomType { lab, pod }

extension RoomTypeString on RoomType {
  RoomType? toEnum(String value) {
    switch (value) {
      case "lab":
        return RoomType.lab;
      case "pod":
        return RoomType.pod;
      default:
        return null;
    }
  }
}

enum Popularity { empty, quiet, medium, busy, very_busy }

extension PopularityString on Popularity {
  Popularity? toEnum(String value) {
    switch (value) {
      case "empty":
        return Popularity.empty;
      case "quiet":
        return Popularity.quiet;
      case "medium":
        return Popularity.medium;
      case "busy":
        return Popularity.busy;
      case "very_busy":
        return Popularity.very_busy;
      default:
        return null;
    }
  }
}
