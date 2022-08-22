import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/lab.dart';

class LabBubble extends StatelessWidget {
  const LabBubble({Key? key, required this.lab}) : super(key: key);
  final Lab? lab;

  @override
  Widget build(BuildContext context) {
    // if (lab == null) {
    //   return Card(
    //       color: Theme.of(context).primaryColor,
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    //       child: const Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //           child: Center(
    //               child: Text(
    //             "No Lab Scheduled",
    //             style: TextStyle(color: Colors.white),
    //           ))));
    // }
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                lab!.getIcon(),
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lab!.module.code,
                  style: GoogleFonts.openSans(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  lab!.getStartTime() + " - " + lab!.getEndTime(),
                  style: GoogleFonts.openSans(color: Colors.white),
                )
              ],
            )
          ])),
    );
  }
}
