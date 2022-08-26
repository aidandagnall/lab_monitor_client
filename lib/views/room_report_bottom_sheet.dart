import 'package:flutter/material.dart';
import 'package:lab_availability_checker/api/report_api.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/report.dart';
import 'package:lab_availability_checker/models/room.dart';

class RoomReportBottomSheet extends StatefulWidget {
  const RoomReportBottomSheet({Key? key, required this.room}) : super(key: key);
  final Room room;

  @override
  createState() => _RoomReportBottomSheetState();
}

class _RoomReportBottomSheetState extends State<RoomReportBottomSheet> {
  Popularity popularity = Popularity.empty;
  bool beenRemoved = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surface),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Submit a live report for ${widget.room.name}"),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text("Empty"),
                        Expanded(
                            child: Slider(
                          value: popularity.index.toDouble(),
                          onChanged: (value) => setState(() {
                            popularity = Popularity.values[value.toInt()];
                          }),
                          min: 0,
                          max: 4,
                          divisions: widget.room.type == RoomType.lab ? 4 : 1,
                        )),
                        const Text("Full"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Asked to leave"),
                        Switch(
                            value: beenRemoved,
                            onChanged: (value) => setState(
                                  () => beenRemoved = value,
                                ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              ReportApi().submitReport(Report(
                                  room: widget.room.name,
                                  popularity: popularity,
                                  removalChance:
                                      beenRemoved ? RemovalChance.definite : RemovalChance.low));
                              Navigator.pop(context);
                            },
                            child: const Text("Submit"))
                      ],
                    )
                  ])),
              const SizedBox(
                height: 40,
              )
            ],
          )),
    );
  }
}
