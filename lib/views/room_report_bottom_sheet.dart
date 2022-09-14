import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/api/report_api.dart';
import 'package:lab_availability_checker/models/popularity.dart';
import 'package:lab_availability_checker/models/removal_chance.dart';
import 'package:lab_availability_checker/models/report.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surface),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Submit a live report for ${widget.room.name}",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Empty",
                          style: TextStyle(fontSize: 18),
                        ),
                        Expanded(
                            child: Slider(
                          value: popularity.index.toDouble(),
                          onChanged: (value) => setState(() {
                            popularity = Popularity.values[value.toInt()];
                          }),
                          min: 0,
                          max: 4,
                          divisions: widget.room.getNumberOfPopularityIntervals(),
                        )),
                        const Text(
                          "Full",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Asked to leave",
                          style: TextStyle(fontSize: 18),
                        ),
                        Switch(
                            value: beenRemoved,
                            onChanged: (value) => setState(
                                  () => beenRemoved = value,
                                ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Disclaimer: Your email will be included with this report",
                        textAlign: TextAlign.center, style: GoogleFonts.openSans()),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<AuthProvider>(
                            builder: (context, provider, child) => ElevatedButton(
                                onPressed: () {
                                  ReportApi().submitReport(
                                      Report(
                                          room: widget.room.name,
                                          popularity: popularity,
                                          email: provider.credentials!.user.email!,
                                          removalChance: beenRemoved
                                              ? RemovalChance.definite
                                              : RemovalChance.low),
                                      provider.credentials!.accessToken);
                                  Navigator.pop(context, true);
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15))))),
                                child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Submit", style: TextStyle(fontSize: 20)))))
                      ],
                    )
                  ])),
              const SizedBox(
                height: 10,
              )
            ],
          )),
    );
  }
}
