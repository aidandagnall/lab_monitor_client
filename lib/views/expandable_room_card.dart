import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/lab_bubble.dart';
import 'package:lab_availability_checker/views/room_report_bottom_sheet.dart';
import 'package:lab_availability_checker/views/status_indicator.dart';

class ExpandableRoomCard extends StatefulWidget {
  const ExpandableRoomCard(
      {Key? key, required this.room, this.expanded = false, this.onReportSubmission})
      : super(key: key);
  final Room room;
  final bool expanded;
  final void Function()? onReportSubmission;
  @override
  createState() => _ExpandableRoomCardState();
}

class _ExpandableRoomCardState extends State<ExpandableRoomCard>
    with SingleTickerProviderStateMixin {
  bool _selected = false;

  @override
  void initState() {
    _selected = widget.expanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            child: InkWell(
                onTap: () => setState(() {
                      _selected = !_selected;
                    }),
                onLongPress: () async {
                  final submitted = await showModalBottomSheet<bool>(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (ctx) => RoomReportBottomSheet(room: widget.room));
                  if (submitted == true) {
                    widget.onReportSubmission == null ? {} : widget.onReportSubmission!();
                  }
                },
                child: Column(
                  children: [
                    if (widget.room.name == "A32")
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 180,
                            child: Ink.image(
                              image: const AssetImage('assets/images/a32.jpg'),
                              fit: BoxFit.cover,
                            ),
                          )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Stack(children: [
                          Positioned.fill(
                              child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SizedBox(
                                      height: 66,
                                      width: 50,
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Center(
                                              child: Text(widget.room.name,
                                                  style: GoogleFonts.openSans(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w400,
                                                  )))))),
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: AnimatedAlign(
                                          curve: Curves.ease,
                                          duration: const Duration(milliseconds: 500),
                                          alignment: _selected
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: StatusIndicator(room: widget.room))))
                            ],
                          )),
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (widget.room.currentLab == null && widget.room.nextLab == null)
                                  AnimatedOpacity(
                                      curve: Curves.ease,
                                      opacity: _selected ? 0 : 1,
                                      duration: const Duration(milliseconds: 300),
                                      child: SizedBox(
                                          height: 66,
                                          child: Center(
                                              child: Padding(
                                                  padding: const EdgeInsets.only(right: 5),
                                                  child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(
                                                        "No more labs today",
                                                        style: GoogleFonts.openSans(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onSurfaceVariant,
                                                        ),
                                                      )))))),
                                if (widget.room.currentLab != null)
                                  AnimatedSwitcher(
                                      // curve: Curves.ease,
                                      // opacity: _selected ? 0 : 1,
                                      switchInCurve: Curves.ease,
                                      switchOutCurve: Curves.ease,
                                      duration: const Duration(milliseconds: 300),
                                      child: !_selected
                                          ? Row(mainAxisSize: MainAxisSize.min, children: [
                                              Center(child: LabBubble(lab: widget.room.currentLab))
                                            ])
                                          : const SizedBox(
                                              height: 66,
                                            )),
                                if (widget.room.currentLab == null && widget.room.nextLab != null)
                                  AnimatedSwitcher(
                                      // curve: Curves.ease,
                                      // opacity: _selected ? 0 : 1,
                                      switchInCurve: Curves.ease,
                                      switchOutCurve: Curves.ease,
                                      duration: const Duration(milliseconds: 300),
                                      child: !_selected
                                          ? Row(children: [
                                              Center(child: LabBubble(lab: widget.room.nextLab))
                                            ])
                                          : const SizedBox(
                                              height: 66,
                                            )),
                              ])
                        ])),
                    AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                        child: _selected
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text("Now"),
                                        widget.room.currentLab == null
                                            ? const SizedBox(
                                                height: 58,
                                                width: 145,
                                                child: Center(child: Text("No Lab Scheduled")))
                                            : LabBubble(lab: widget.room.currentLab)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text("Next"),
                                        widget.room.nextLab == null
                                            ? const SizedBox(
                                                height: 58,
                                                width: 145,
                                                child: Center(child: Text("No Lab Scheduled")))
                                            : LabBubble(lab: widget.room.nextLab)
                                      ],
                                    ),
                                  ],
                                ))
                            : Container()),
                  ],
                ))));
  }
}
