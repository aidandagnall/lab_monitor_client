import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lab_availability_checker/api/user_api.dart';
import 'package:lab_availability_checker/models/module.dart';
import 'package:lab_availability_checker/models/module_code.dart';
import 'package:lab_availability_checker/providers/enable_tooltip_provider.dart';
import 'package:lab_availability_checker/providers/expanded_card_provider.dart';
import 'package:lab_availability_checker/providers/module_code_provider.dart';
import 'package:lab_availability_checker/providers/theme_provider.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/util/constants.dart';
import 'package:lab_availability_checker/views/admin_panel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key, required this.auth}) : super(key: key);
  final AuthProvider auth;

  @override
  createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool darkMode = false;
  late final SharedPreferences prefs;
  late Future<void> _permissionsList;
  List<String>? permissions;

  @override
  void initState() {
    getPreferences();
    super.initState();
    _permissionsList = getPermissions();
  }

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool('settings/dark-mode') ?? false;
  }

  Future<void> getPermissions() async {
    final _p =
        await UserApi().getPermissions((await widget.auth.getStoredCredentials())!.accessToken) ??
            [];
    permissions = _p;
    print(permissions);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Consumer<AuthProvider>(
                builder: (context, auth, child) => FutureBuilder(
                    future: _permissionsList,
                    builder: ((context, snapshot) {
                      if (permissions != null &&
                          permissions!.any((e) => Constants.ADMIN_PERMISSIONS.contains(e))) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => AdminPanel(
                                        permissions: permissions!,
                                      )))),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 30),
                              child: Row(children: const [Text("Admin Panel")])),
                        );
                      } else {
                        return Container();
                      }
                    }))),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Dark Mode"),
                    Consumer<ThemeProvider>(builder: (c, themeProvider, child) {
                      return Switch(
                          value: themeProvider.selectedMode == ThemeMode.dark,
                          onChanged: (value) => themeProvider
                              .setSelectedThemeMode(value ? ThemeMode.dark : ThemeMode.light));
                    })
                  ],
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Module Code Style"),
                    Consumer<ModuleCodeStyleProvider>(
                        builder: (ctx, provider, child) => IntrinsicWidth(
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<ModuleCodeStyle>(
                              itemHeight: 50,
                              value: provider.style,
                              items: ModuleCodeStyle.values
                                  .map((e) => DropdownMenuItem<ModuleCodeStyle>(
                                      value: e,
                                      child: Text(Module(
                                          abbreviation: "PGA",
                                          code: "COMP1005",
                                          name: "Programming for Computer Scientists",
                                          convenor: ["Jamie Twycross"]).getModuleCodeWithStyle(e))))
                                  .toList(),
                              onChanged: (style) => provider.setSelectedStyle(style!),
                            ))))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Auto Expand Rooms"),
                  Consumer<ExpandedCardProvider>(
                      builder: (ctx, provider, child) => Switch(
                          value: provider.expanded,
                          onChanged: (value) => provider.setExpanded(value)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Enable Module Tooltips"),
                  Consumer<EnableTooltipProvider>(
                      builder: (ctx, provider, child) => Switch(
                          value: provider.enabled,
                          onChanged: (value) => provider.setEnabled(value)))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Hint: You can long-press on a room to submit a live report!",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Center(child: Text("Created by Aidan Dagnall")),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                        child: Text(
                            "Thanks to Ben Flynn and Joe Sieniawski for their contributions in creating designs for this app",
                            textAlign: TextAlign.center)),
                    const SizedBox(
                      height: 60,
                    ),
                    const Center(
                        child: Text("Have a suggestion or want to help out?",
                            textAlign: TextAlign.center)),
                    Center(
                      child: TextButton(
                          onPressed: () async => await launchUrl(
                              Uri.parse("https://github.com/aidandagnall/lab_monitor_client")),
                          child: const Text("Get Involved")),
                    )
                  ],
                )),
            Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Consumer<AuthProvider>(
                      builder: (context, provider, child) => TextButton(
                          onPressed: () async {
                            provider.logout();
                          },
                          child: const Text(
                            "Logout",
                          )),
                    )))
          ],
        )));
  }
}
