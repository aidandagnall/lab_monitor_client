import 'package:lab_availability_checker/models/popularity.dart';
import 'package:lab_availability_checker/models/removal_chance.dart';

class Report {
  final int? id;
  final String room;
  final Popularity? popularity;
  final RemovalChance? removalChance;
  final String email;
  final DateTime? time;

  const Report(
      {this.id,
      required this.room,
      required this.email,
      this.popularity,
      this.removalChance,
      this.time});

  Map<String, dynamic> toJson() => {
        'room': room,
        "popularity": popularity?.name,
        "removalChance": removalChance?.name,
        "email": email,
      };
  factory Report.fromJson(Map<String, dynamic> json) {
    final timeValues = (json['time'] as List).map((e) => e as int).toList();
    return Report(
        id: json['id'],
        room: json['room'],
        popularity: json['popularity'] == null
            ? null
            : Popularity.values
                .singleWhere((e) => e.toString() == "Popularity." + json['popularity']),
        removalChance: json['removalChance'] == null
            ? null
            : RemovalChance.values
                .singleWhere((e) => e.toString() == "RemovalChance." + json['removalChance']),
        email: json['email'],
        time: DateTime(timeValues[0], timeValues[1], timeValues[2], timeValues[3], timeValues[4]));
  }
}
