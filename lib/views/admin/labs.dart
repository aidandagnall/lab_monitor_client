import 'package:flutter/material.dart';
import 'package:lab_availability_checker/api/lab_api.dart';
import 'package:lab_availability_checker/api/module_api.dart';
import 'package:lab_availability_checker/api/room_api.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:lab_availability_checker/models/module.dart';
import 'package:lab_availability_checker/models/removal_chance.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class LabAdminPage extends StatefulWidget {
  const LabAdminPage({Key? key, required this.auth}) : super(key: key);
  final AuthProvider auth;

  @override
  State<StatefulWidget> createState() => _LabAdminPage();
}

class _LabAdminPage extends State<LabAdminPage> {
  List<Lab>? labs;

  @override
  void initState() {
    getLabs();
    super.initState();
  }

  Future<void> getLabs() async {
    final l = await LabApi().getLabs((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      labs = l;
    });
  }

  void deleteLab(int id) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Labs"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context, builder: ((context) => CreateLabDialog(auth: widget.auth)));
          },
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              labs == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: labs!.length,
                      itemBuilder: (context, index) => _LabCard(
                          lab: labs![index],
                          onDelete: () async {
                            final success = await LabApi().deleteLab(
                                (await widget.auth.getStoredCredentials())!.accessToken,
                                labs![index].id!);
                            if (success) {
                              setState(() {
                                labs!.remove(labs![index]);
                              });
                            }
                          })),
            ])));
  }
}

class _LabCard extends StatelessWidget {
  const _LabCard({Key? key, required this.lab, required this.onDelete}) : super(key: key);
  final Lab lab;
  final void Function()? onDelete;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Code: " + lab.module.code),
                Text("Day: " + lab.day.toString()),
                Text("${lab.startTime}-${lab.endTime}"),
                Text("Room(s): ${lab.rooms}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onDelete != null)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: IconButton(onPressed: onDelete, icon: const Icon(Icons.close))),
                  ],
                )
              ],
            )));
  }
}

class CreateLabDialog extends StatefulWidget {
  const CreateLabDialog({Key? key, required this.auth}) : super(key: key);
  final AuthProvider auth;

  @override
  State<StatefulWidget> createState() => _CreateLabDialogState();
}

class _CreateLabDialogState extends State<CreateLabDialog> {
  TextEditingController moduleCodeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  Room? selectedRoom;
  Module? selectedModule;
  RemovalChance? removalChance;
  List<bool?> selectedDay = [null, false, false, false, false, false, null];

  List<Room>? rooms;
  List<Module>? modules;

  @override
  void initState() {
    getRooms();
    getModules();
    super.initState();
  }

  Future<void> getRooms() async {
    final r = await RoomApi().getRooms((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      rooms = r;
    });
  }

  Future<void> getModules() async {
    final m = await ModuleApi().getModules((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      modules = m;
    });
  }

  Future<bool> postLab(Lab lab) async {
    return await LabApi().postLab((await widget.auth.getStoredCredentials())!.accessToken, lab);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IntrinsicHeight(
            child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: modules == null
                                ? const Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<Module>(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(), labelText: "Module"),
                                    value: selectedModule,
                                    items: modules!
                                        .map((e) => DropdownMenuItem<Module>(
                                              child: Text(e.code),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (module) => setState(() {
                                          selectedModule = module;
                                        }))),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: rooms == null
                                ? const Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<Room>(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(), labelText: "Room"),
                                    value: selectedRoom,
                                    items: rooms!
                                        .where((e) => e.type == RoomType.lab)
                                        .map((e) => DropdownMenuItem<Room>(
                                              child: Text(e.name),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (room) => setState(() {
                                          selectedRoom = room;
                                        }))),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: WeekdaySelector(
                            firstDayOfWeek: 1,
                            values: selectedDay,
                            onChanged: (value) => setState(() {
                              selectedDay = [null, false, false, false, false, false, null];
                              selectedDay[value] = true;
                            }),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: startTimeController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Start Time (e.g. 1100, 1400)"),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: endTimeController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "End Time (e.g. 1100, 1400)"),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: DropdownButtonFormField<RemovalChance>(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(), labelText: "Removal Chance"),
                                value: removalChance,
                                items: RemovalChance.values
                                    .map((e) => DropdownMenuItem<RemovalChance>(
                                          child: Text(e.name),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (r) => setState(() {
                                      removalChance = r;
                                    }))),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                primary: Theme.of(context).colorScheme.primary,
                                onPrimary: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: () async {
                                final success = await postLab(Lab(
                                    module: selectedModule!,
                                    day: selectedDay.indexWhere((e) => e == true),
                                    startTime: startTimeController.text,
                                    endTime: endTimeController.text,
                                    removalChance: removalChance,
                                    rooms: [selectedRoom!.name]));
                                if (success) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Submit"),
                            )),
                      ])),
                ))));
  }
}
