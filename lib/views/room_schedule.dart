import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/api/lab_api.dart';
import 'package:lab_availability_checker/api/room_api.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:tuple/tuple.dart';

class RoomScheduleView extends StatefulWidget {
  final AuthProvider auth;

  const RoomScheduleView({Key? key, required this.auth}) : super(key: key);
  @override
  createState() => _RoomScheduleViewState();
}

class _RoomScheduleViewState extends State<RoomScheduleView> {
  Room? room;
  List<Room>? rooms;
  List<Lab>? labs;

  @override
  void initState() {
    getLabs();
    getRooms();
    super.initState();
  }

  Future<void> getRooms() async {
    final r = await RoomApi().getRooms((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      rooms = r;
    });
  }

  Future<void> getLabs() async {
    final l = await LabApi().getLabs((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      labs = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                color: Theme.of(context).colorScheme.surface),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: rooms == null
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: 40,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: rooms!
                                    .where((e) => e.type == RoomType.lab)
                                    .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: ChoiceChip(
                                            label: Text(
                                              e.name,
                                              style: GoogleFonts.openSans(
                                                  color: room == e
                                                      ? Theme.of(context).colorScheme.onPrimary
                                                      : Theme.of(context).colorScheme.onSurface),
                                            ),
                                            selected: room == e,
                                            selectedColor: Theme.of(context).colorScheme.primary,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                room = e;
                                              });
                                            })))
                                    .toList(),
                              ))),
                  if (room != null)
                    SizedBox(
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Tuple2(1, "Monday"),
                              Tuple2(2, "Tuesday"),
                              Tuple2(3, "Wednesday"),
                              Tuple2(4, "Thursday"),
                              Tuple2(5, "Friday"),
                            ]
                                .map((tuple) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: StickyHeader(
                                        header: Container(
                                            height: 40.0,
                                            color: Theme.of(context).colorScheme.surface,
                                            // padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              tuple.item2,
                                              style: GoogleFonts.openSans(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            )),
                                        content: Column(
                                          children: (labs!
                                                ..sort(
                                                    (a, b) => a.startTime.compareTo(b.startTime)))
                                              .where((e) =>
                                                  e.day == tuple.item1 &&
                                                  e.rooms.contains(room!.name))
                                              .map(
                                                (e) => Card(
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(15),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Flexible(
                                                                  child: Text(
                                                                e.module.name,
                                                                softWrap: false,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.openSans(
                                                                    color: Theme.of(context)
                                                                        .colorScheme
                                                                        .onPrimaryContainer),
                                                              )),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(e.module.code),
                                                            ],
                                                          ),
                                                          Text(e.getStartTime() +
                                                              " - " +
                                                              e.getEndTime())
                                                        ],
                                                      )),
                                                ),
                                              )
                                              .toList(),
                                        ))))
                                .toList()))
                  else
                    const SizedBox(
                      height: 300,
                      child: Center(child: Text("Select a room")),
                    )
                ]),
              ),
            )));
  }
}
