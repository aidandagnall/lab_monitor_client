import 'package:flutter/material.dart';
import 'package:lab_availability_checker/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool darkMode = false;
  late final SharedPreferences prefs;

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool('settings/dark-mode') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
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
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: const [
                    Center(child: Text("Created by Aidan Dagnall")),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                            "Thanks to Ben Flynn and Joe Sienawski for their contributions in creating designs for this app",
                            textAlign: TextAlign.center)),
                  ],
                ))
          ],
        ));
  }
}
