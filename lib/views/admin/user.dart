import 'package:flutter/material.dart';
import 'package:lab_availability_checker/api/user_api.dart';
import 'package:lab_availability_checker/models/user.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserAdminPage extends StatefulWidget {
  const UserAdminPage({Key? key, this.email = ""}) : super(key: key);
  final String email;
  @override
  createState() => _UserAdminPageState();
}

class _UserAdminPageState extends State<UserAdminPage> {
  late TextEditingController emailController;
  TextEditingController newPermissionController = TextEditingController();
  User? user;
  @override
  void initState() {
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Users"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "User ID / Email",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  )),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Consumer<AuthProvider>(
                          builder: (context, auth, child) => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: Icon(
                                      Icons.search,
                                      size: 28,
                                    )),
                                onPressed: () async {
                                  final u = await UserApi().getUser(
                                      (await auth.getStoredCredentials())!.accessToken,
                                      emailController.text);
                                  setState(() {
                                    user = u;
                                  });
                                },
                              )))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              user == null
                  ? const Center(child: Text("Not found"))
                  : Expanded(
                      child: SingleChildScrollView(
                          child: Card(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email: " + user!.email),
                              Text("ID: " + user!.id),
                              Column(
                                  children: user!.permissions
                                      .map(
                                        (e) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(e),
                                            Consumer<AuthProvider>(
                                                builder: (context, auth, child) => IconButton(
                                                    onPressed: () async {
                                                      final success = await UserApi()
                                                          .removeUserPermission(
                                                              (await auth.getStoredCredentials())!
                                                                  .accessToken,
                                                              user!.id,
                                                              e);
                                                      if (success) {
                                                        setState(() {
                                                          user!.permissions.remove(e);
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(Icons.close)))
                                          ],
                                        ),
                                      )
                                      .toList()),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                Expanded(
                                    child: TextFormField(
                                  controller: newPermissionController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "New Permission",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  ),
                                )),
                                Consumer<AuthProvider>(
                                    builder: (context, auth, child) => IconButton(
                                        onPressed: () async {
                                          final success = await UserApi().addUserPermission(
                                              (await auth.getStoredCredentials())!.accessToken,
                                              user!.id,
                                              newPermissionController.text);
                                          if (success) {
                                            setState(() {
                                              user!.permissions.add(newPermissionController.text);
                                              newPermissionController.clear();
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.add)))
                              ]),
                            ],
                          )),
                    ))),
            ],
          )),
    );
  }
}
