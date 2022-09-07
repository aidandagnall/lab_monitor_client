import 'package:flutter/material.dart';
import 'package:lab_availability_checker/models/module.dart';
import 'package:lab_availability_checker/models/module_code.dart';
import 'package:lab_availability_checker/util/module_code_provider.dart';
import 'package:lab_availability_checker/util/theme_provider.dart';
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
                              // decoration: const InputDecoration(
                              //   border: OutlineInputBorder(),
                              //   focusedBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                              //   enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                              // ),
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
                              onChanged: (style) =>
                                  setState(() => provider.setSelectedStyle(style!)),
                            ))))
                  ],
                )),
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
                            "Thanks to Ben Flynn and Joe Sieniawski for their contributions in creating designs for this app",
                            textAlign: TextAlign.center)),
                  ],
                ))
          ],
        ));
  }
}
