import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lab_availability_checker/api/room_api.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/views/expandable_room_card.dart';
import 'package:lab_availability_checker/views/pod_room_card.dart';
import 'package:lab_availability_checker/views/large_room_card.dart';
import 'package:lab_availability_checker/views/small_room_card.dart';

class NowView extends StatefulWidget {
  const NowView({Key? key}) : super(key: key);

  @override
  createState() => _NowViewState();
}

class _NowViewState extends State<NowView> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();
  late Future<void> _roomList;
  List<Room>? _rooms;
  @override
  void initState() {
    super.initState();
    _roomList = _getRooms();
  }

  Future<void> _getRooms() async {
    final r = await RoomApi().getRooms();
    _rooms = r;
  }

  Future<void> _refreshRooms() async {
    final r = await RoomApi().getRooms();
    setState(() {
      _rooms = r;
    });
    return Future.delayed(Duration(seconds: 0));
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
                  child: PodRoomCard(room: _pods[0]),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: PodRoomCard(room: _pods[1]),
                )),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: PodRoomCard(room: _pods[2]),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: PodRoomCard(room: _pods[3]),
                )),
              ],
            ),
          ];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () => _refreshRooms(),
                  edgeOffset: 40,
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
                          child = ExpandableRoomCard(room: _labs[index]);
                        }
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                                verticalOffset: 50, child: FadeInAnimation(child: child)));
                      },
                    ),
                  )));
        }));
  }
}
