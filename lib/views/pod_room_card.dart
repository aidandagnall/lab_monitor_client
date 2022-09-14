import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/room_report_bottom_sheet.dart';
import 'package:lab_availability_checker/views/status_indicator.dart';

class PodRoomCard extends StatelessWidget {
  const PodRoomCard({
    Key? key,
    required this.room,
    this.onReportSubmission,
  }) : super(key: key);
  final Room room;
  final void Function()? onReportSubmission;
  @override
  Widget build(BuildContext context) {
    return Card(
        semanticContainer: true,
        margin: const EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
            onLongPress: () async {
              final submitted = await showModalBottomSheet<bool>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  context: context,
                  builder: (ctx) => RoomReportBottomSheet(room: room));
              if (submitted == true) {
                onReportSubmission == null ? {} : onReportSubmission!();
              }
            },
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
                    const Spacer(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 15, right: 10),
                              child: StatusIndicator(room: room)),
                        ])
                  ])),
            )));
  }
}
