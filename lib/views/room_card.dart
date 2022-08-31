import 'package:flutter/material.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/room_report_bottom_sheet.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({Key? key, required this.child, required this.room}) : super(key: key);
  final Widget child;
  final Room room;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) => RoomReportBottomSheet(room: room)),
      child: child,
    );
  }

  Widget reportBottomSheet(BuildContext context) {
    RemovalChance removalChance = RemovalChance.low;
    Popularity popularity = Popularity.empty;
    return Container(
      decoration:
          const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Submit a live report for ${room.name}"),
              Slider(
                value: popularity.index.toDouble(),
                onChanged: (value) => popularity = Popularity.values[value.toInt()],
                min: 0,
                max: 4,
                divisions: 5,
              ),
              // DropdownButtonHideUnderline(
              //     child: DropdownButtonFormField<RemovalChance>(
              //   items: RemovalChance.values
              //       .map((e) => DropdownMenuItem(child: Text(e.name), value: e))
              //       .toList(),
              //   onChanged: (value) => removalChance = value,
              // )),
              // DropdownButtonHideUnderline(
              //   child: DropdownButtonFormField<Popularity>(
              //     items: Popularity.values
              //         .map((e) => DropdownMenuItem(child: Text(e.name), value: e))
              //         .toList(),
              //     onChanged: (value) => popularity = value,
              //   ),
              // )
            ],
          )),
    );
  }
}
