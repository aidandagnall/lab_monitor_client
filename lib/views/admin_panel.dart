import 'package:flutter/material.dart';
import 'package:lab_availability_checker/api/room_api.dart';
import 'package:lab_availability_checker/models/room.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/views/admin/issues.dart';
import 'package:lab_availability_checker/views/admin/labs.dart';
import 'package:lab_availability_checker/views/admin/reports.dart';
import 'package:lab_availability_checker/views/admin/user.dart';
import 'package:provider/provider.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({Key? key, required this.permissions}) : super(key: key);
  final List<String> permissions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Admin Panel"),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              if (permissions.contains("create:lab"))
                AdminActionButton(
                    title: "Labs",
                    onTap: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer<AuthProvider>(
                                builder: (context, auth, child) => LabAdminPage(auth: auth)))))),
              if (permissions.contains("delete:report"))
                AdminActionButton(
                    title: "Reports",
                    onTap: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer<AuthProvider>(
                                builder: (context, auth, child) => ReportAdminPage(auth: auth)))))),
              if (permissions.contains("read:issues"))
                AdminActionButton(
                    title: "Issues",
                    onTap: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer<AuthProvider>(
                                builder: (context, auth, child) => IssuesAdminPage(auth: auth)))))),
              if (permissions.contains("edit:user"))
                AdminActionButton(
                    title: "Users",
                    onTap: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Consumer<AuthProvider>(
                                builder: (context, auth, child) => const UserAdminPage()))))),
            ])));
  }
}

class AdminActionButton extends StatelessWidget {
  const AdminActionButton({Key? key, required this.title, required this.onTap}) : super(key: key);
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  )
                ]))));
  }
}

class CreateLabDialog extends StatefulWidget {
  const CreateLabDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateLabDialogState();
}

class _CreateLabDialogState extends State<CreateLabDialog> {
  TextEditingController moduleCodeController = TextEditingController();
  Room? selectedRoom;
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
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Module Code"),
                        ),
                        Consumer<AuthProvider>(
                            builder: ((context, provider, child) => FutureBuilder<List<Room>?>(
                                future: RoomApi().getRooms(provider.credentials!.accessToken),
                                builder: ((context, snapshot) => DropdownButtonFormField<Room>(
                                    value: null,
                                    items: snapshot.hasData && snapshot.data != null
                                        ? snapshot.data!
                                            .map((e) => DropdownMenuItem<Room>(
                                                  child: Text(e.name),
                                                  value: e,
                                                ))
                                            .toList()
                                        : [DropdownMenuItem(child: Text("Test"))],
                                    onChanged: (room) => selectedRoom = room))))),
                      ])),
                ))));
  }
}
