import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/lab_bubble.dart';
import 'package:lab_availability_checker/views/room_card.dart';
import 'package:lab_availability_checker/views/status_indicator.dart';

class SmallRoomCard extends StatelessWidget {
  const SmallRoomCard({Key? key, required this.room}) : super(key: key);
  final Room room;
  @override
  Widget build(BuildContext context) {
    return Card(
        semanticContainer: true,
        margin: const EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: RoomCard(
          room: room,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                        width: 50,
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(room.name,
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ))))),
                Padding(
                    padding: const EdgeInsets.only(left: 15), child: StatusIndicator(room: room)),
                const Spacer(),
                if (room.currentLab == null && room.nextLab == null)
                  SizedBox(
                      height: 66,
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                "No more labs today",
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              )))),
                if (room.currentLab != null) Row(children: [LabBubble(lab: room.currentLab)]),
                if (room.currentLab == null && room.nextLab != null)
                  Row(children: [LabBubble(lab: room.nextLab)]),
              ])),
        ));
  }
}
