import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/room.dart';

class Report {
  final String room;
  final Popularity? popularity;
  final RemovalChance? removalChance;

  const Report({required this.room, this.popularity, this.removalChance});

  Map<String, dynamic> toJson() => {
        'room': room,
        "popularity": popularity?.name,
        "removalChance": removalChance?.name,
      };
}
