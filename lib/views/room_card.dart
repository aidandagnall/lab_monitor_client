import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/room.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({Key? key, required this.room}) : super(key: key);
  final Room room;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      margin: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Stack(
        children: [
          Container(
            height: 200,
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [room.getStatusColour(), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0, 0.7])),
            child: Image.asset(
              'assets/images/a32.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(room.name,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(room.name),
                    ),
                    Text(room.name),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
