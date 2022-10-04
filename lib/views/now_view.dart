import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/api/room_api.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/views/expandable_room_card.dart';
import 'package:lab_availability_checker/views/pod_room_card.dart';
import 'package:lab_availability_checker/views/room_schedule.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/expanded_card_provider.dart';

class NowView extends StatefulWidget {
  const NowView({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthProvider auth;

  @override
  createState() => _NowViewState();
}

class _NowViewState extends State<NowView> {
  late Future<void> _roomList;
  List<Room>? _rooms;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!((await SharedPreferences.getInstance()).getBool("settings/seen-tutorial") ?? false)) {
        _showTutorial();
      }
    });
    _roomList = _getRooms();
  }

  Future<void> _getRooms() async {
    final r = await RoomApi().getRooms((await widget.auth.getStoredCredentials())!.accessToken);
    _rooms = r;
  }

  Future<void> _refreshRooms() async {
    _refreshKey.currentState?.show();
    final r = await RoomApi().getRooms((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      _rooms = r;
    });
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _roomList,
        builder: ((context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_rooms == null) {
            return const Center(child: CircularProgressIndicator());
          }
          _rooms = _rooms!
            ..sort((a, b) {
              if (a.name == "A32") {
                return -1;
              }
              if (b.name == "A32") {
                return 1;
              }
              return a.name.compareTo(b.name);
            });
          final _labs = _rooms!.where((e) => e.type == RoomType.lab).toList();
          final _pods = _rooms!.where((e) => e.type == RoomType.pod).toList();
          final _podRows = [
            Padding(
                padding: const EdgeInsets.only(top: 25, left: 4, right: 4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text("Pods"),
                  Divider(
                    color: Colors.black,
                  )
                ])),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: PodRoomCard(
                    room: _pods[0],
                    onReportSubmission: _refreshRooms,
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: PodRoomCard(
                    room: _pods[1],
                    onReportSubmission: _refreshRooms,
                  ),
                )),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: PodRoomCard(
                    room: _pods[2],
                    onReportSubmission: _refreshRooms,
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: PodRoomCard(
                    room: _pods[3],
                    onReportSubmission: _refreshRooms,
                  ),
                )),
              ],
            ),
          ];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () => _refreshRooms(),
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: AnimationLimiter(
                        child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                          childAnimationBuilder: (child) => SlideAnimation(
                              verticalOffset: 50, child: FadeInAnimation(child: child)),
                          children: [
                            ElevatedButton(
                                onPressed: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.vertical(top: Radius.circular(20))),
                                    context: context,
                                    builder: (context) => RoomScheduleView(auth: widget.auth)),
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  primary: Theme.of(context).colorScheme.primary,
                                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                                ),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                            "Room Schedules",
                                            style: GoogleFonts.openSans(fontSize: 18),
                                          )),
                                    ])),
                            ..._labs
                                .map((e) => Consumer<ExpandedCardProvider>(
                                    builder: (ctx, provider, value) => ExpandableRoomCard(
                                          room: e,
                                          expanded: provider.expanded,
                                          onReportSubmission: _refreshRooms,
                                        )))
                                .toList(),
                            ..._podRows,
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Hold on a room to submit a report",
                              style: GoogleFonts.openSans(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                      ))));
        }));
  }

  _showTutorial() async {
    await (await SharedPreferences.getInstance()).setBool("settings/seen-tutorial", true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Welcome to Lab Monitor',
            textAlign: TextAlign.center,
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: const [
            Text(
              "Tap on a card to expand it",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Hold a card to submit a live report",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Submit technical issues with University equipment on the Issues screen by scanning the location code",
              textAlign: TextAlign.center,
            ),
          ]),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text("OK"))
          ],
        );
      },
    );
  }
}
