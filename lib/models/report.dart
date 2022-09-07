import 'package:lab_availability_checker/models/popularity.dart';
import 'package:lab_availability_checker/models/removal_chance.dart';

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
