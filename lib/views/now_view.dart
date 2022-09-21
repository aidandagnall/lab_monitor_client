import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lab_availability_checker/api/room_api.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/views/expandable_room_card.dart';
import 'package:lab_availability_checker/views/pod_room_card.dart';
import 'package:provider/provider.dart';

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
                  edgeOffset: 100,
                  child: AnimationLimiter(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _labs.length + _podRows.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final Widget child;
                        if (index >= _labs.length) {
                          child = _podRows[index - _labs.length];
                        } else {
                          child = Consumer<ExpandedCardProvider>(
                              builder: (ctx, provider, value) => ExpandableRoomCard(
                                    room: _labs[index],
                                    expanded: provider.expanded,
                                    onReportSubmission: _refreshRooms,
                                  ));
                        }
                        return Padding(
                            padding: EdgeInsets.only(top: index == 0 ? 40 : 0),
                            child: AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 400),
                                child: SlideAnimation(
                                    verticalOffset: 50, child: FadeInAnimation(child: child))));
                      },
                    ),
                  )));
        }));
  }
}
