import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/module.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/lab_bubble.dart';
import 'package:lab_availability_checker/views/room_card.dart';
import 'package:lab_availability_checker/views/status_indicator.dart';

class LargeRoomCard extends StatelessWidget {
  const LargeRoomCard({Key? key, required this.room}) : super(key: key);
  final Room room;

  @override
  Widget build(BuildContext context) {
    return Card(
        semanticContainer: true,
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: RoomCard(
          room: room,
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 180,
                    child: Image.asset(
                      'assets/images/a32.jpg',
                      fit: BoxFit.cover,
                    ),
                  )),
              // Stack(children: [
              //   ClipRRect(
              //       borderRadius: BorderRadius.circular(10),
              //       child: Container(
              //         height: 180,
              //         child: Image.asset(
              //           'assets/images/a32.jpg',
              //           fit: BoxFit.cover,
              //         ),
              //       )),
              //   Container(
              //       // constraints: BoxConstraints(maxWidth: 100),
              //       decoration: BoxDecoration(
              //           color: Theme.of(context).colorScheme.primaryContainer,
              //           borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))),
              //       child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //           child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               // mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Column(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     Padding(
              //                       padding: const EdgeInsets.symmetric(vertical: 0),
              //                       child: Text(room.name,
              //                           style: GoogleFonts.openSans(
              //                             color: Theme.of(context).colorScheme.onSurfaceVariant,
              //                             fontSize: 28,
              //                             fontWeight: FontWeight.w400,
              //                           )),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(left: 0, right: 5),
              //                       child: StatusIndicator(room: room),
              //                     )
              //                   ],
              //                 )
              //               ]))),
              // ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 25),
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
                          padding: const EdgeInsets.only(left: 15),
                          child: StatusIndicator(room: room)),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // if (room.currentLab != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Now"),
                              room.currentLab == null
                                  ? const SizedBox(
                                      height: 58,
                                      width: 145,
                                      child: Center(child: Text("No Lab Scheduled")))
                                  : LabBubble(lab: room.currentLab)
                            ],
                          ),

                          // if (room.currentLab == null && room.nextLab != null)
                          Column(
                            children: [
                              const Text("Next"),
                              room.nextLab == null
                                  ? const SizedBox(
                                      height: 58,
                                      width: 145,
                                      child: Center(child: Text("No Lab Scheduled")))
                                  : LabBubble(lab: room.nextLab)
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
