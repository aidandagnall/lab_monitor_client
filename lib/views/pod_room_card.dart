import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/lab_bubble.dart';
import 'package:lab_availability_checker/views/room_card.dart';
import 'package:lab_availability_checker/views/status_indicator.dart';

class PodRoomCard extends StatelessWidget {
  const PodRoomCard({Key? key, required this.room}) : super(key: key);
  final Room room;
  @override
  Widget build(BuildContext context) {
    return Card(
        semanticContainer: true,
        margin: const EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: RoomCard(
            room: room,
            child: SizedBox(
              height: 40,
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: StatusIndicator(room: room)),
                        ])
                  ])),
            )));
  }
}
