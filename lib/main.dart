import 'dart:io';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lab_availability_checker/models/module_code.dart';
import 'package:lab_availability_checker/providers/enable_tooltip_provider.dart';
import 'package:lab_availability_checker/providers/expanded_card_provider.dart';
import 'package:lab_availability_checker/providers/module_code_provider.dart';
import 'package:lab_availability_checker/providers/theme_provider.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/util/http_override.dart';
import 'package:lab_availability_checker/views/login_page.dart';
import 'package:lab_availability_checker/views/now_view.dart';
import 'package:lab_availability_checker/views/settings_view.dart';
import 'package:lab_availability_checker/views/issue_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  HttpOverrides.global = DevHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF005597),
      brightness: Brightness.light,
    );
    final darkTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF005597),
      brightness: Brightness.dark,
    );
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => ThemeProvider.initial(
                          (snapshot.data!.getBool('settings/dark-mode') ?? false)
                              ? ThemeMode.dark
                              : ThemeMode.light)),
                  ChangeNotifierProvider(
                    create: (_) => ModuleCodeStyleProvider.initial(ModuleCodeStyle
                        .values[snapshot.data!.getInt('settings/module-code-style') ?? 0]),
                  ),
                  ChangeNotifierProvider(
                      create: (_) => ExpandedCardProvider.initial(
                          snapshot.data!.getBool('settings/expanded-cards') ?? false)),
                  ChangeNotifierProvider(
                      create: (_) => EnableTooltipProvider.initial(
                          snapshot.data!.getBool('settings/enabled-tooltips') ?? false)),
                  ChangeNotifierProvider(
                      create: (_) => AuthProvider(snapshot.data!.getBool('login/is-admin') ?? false
                          ? LoginType.admin
                          : LoginType.user)),
                ],
                child: Consumer<ThemeProvider>(
                    child: Consumer<AuthProvider>(builder: ((context, provider, child) {
                  return MyHomePage(auth: provider);
                })), builder: (c, themeProvider, child) {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent, // transparent status bar
                      statusBarBrightness: themeProvider.selectedMode == ThemeMode.light
                          ? Brightness.light
                          : Brightness.dark,
                      statusBarIconBrightness: themeProvider.selectedMode == ThemeMode.light
                          ? Brightness.dark
                          : Brightness.light,
                      systemNavigationBarColor: themeProvider.selectedMode == ThemeMode.light
                          ? lightTheme.colorScheme.surface
                          : darkTheme.colorScheme.surface,
                      systemNavigationBarIconBrightness:
                          themeProvider.selectedMode == ThemeMode.light
                              ? Brightness.dark
                              : Brightness.light));
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'UoN Lab Monitor',
                      theme: lightTheme,
                      darkTheme: darkTheme,
                      themeMode: themeProvider.selectedMode,
                      home: child);
                }));
          }
          return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())));
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.auth}) : super(key: key);
  final AuthProvider auth;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget?> states;
  int currentPage = 1;
  Future<Credentials?>? credentials;
  @override
  void initState() {
    super.initState();
    states = [
      const IssueView(),
      Consumer<AuthProvider>(builder: (_, provider, child) => NowView(auth: provider)),
      Consumer<AuthProvider>(builder: (_, provider, child) => SettingsView(auth: provider)),
    ];
    credentials = widget.auth.getStoredCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, provider, child) => FutureBuilder<Credentials?>(
            future: credentials,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.credentials == null) {
                return const LoginPage();
              }
              return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: SafeArea(top: true, child: states[currentPage]!),
                  bottomNavigationBar: BottomNavigationBar(
                      onTap: (value) => setState(() {
                            currentPage = value;
                          }),
                      currentIndex: currentPage,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.assignment_late_outlined), label: "Issue"),
                        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Now"),
                        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
                      ]));
            }));
  }
}
