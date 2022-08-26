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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: RoomCard(
          room: room,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 180,
                          child: Image.asset(
                            'assets/images/a32.jpg',
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                        child: Text(room.name,
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0, right: 5),
                                        child: StatusIndicator(room: room),
                                      )
                                    ],
                                  )
                                ]))),
                  ])),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              // lab: Lab(
                              //     day: 1,
                              //     rooms: [
                              //       Room(name: 'a32', size: RoomSize.large, type: RoomType.lab)
                              //     ],
                              //     module: Module(
                              //         code: "COMP1003",
                              //         name: "Dr Max L Wilson",
                              //         convenor: ["Test"]),
                              //     startTime: "1100",
                              //     endTime: "1300",
                              //     removalChance: RemovalChance.high)
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

                          // Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 10),
                          //     child: room.currentLab == null
                          //         ? Column(children: [Text("No Labs Scheduled")])
                          //         : Column(
                          //             children: [Text("Currently On:")],
                          //           )),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
