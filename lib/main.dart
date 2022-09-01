import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab_availability_checker/color_schemes.g.dart';
import 'package:lab_availability_checker/theme.dart';
import 'package:lab_availability_checker/views/now_view.dart';
import 'package:lab_availability_checker/views/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
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
                              : ThemeMode.light))
                ],
                child: Consumer<ThemeProvider>(
                    child: const MyHomePage(title: 'Flutter Demo Home Page'),
                    builder: (c, themeProvider, child) {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          // statusBarColor: Theme.of(context).colorScheme.surface,
                          // statusBarColor: themeProvider.selectedMode == ThemeMode.light
                          //     ? lightTheme.colorScheme.surface
                          //     : darkTheme.colorScheme.surface, // transparent status bar
                          // statusBarIconBrightness: ,
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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget?> states = [
    Container(),
    const NowView(),
    const SettingsView(),
  ];
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: AppBar(
      //   toolbarHeight: 0,
      //   systemOverlayStyle: SystemUiOverlayStyle.dark,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      // body: SafeArea(top: false, child: NowView())
      body: SafeArea(top: false, child: states[currentPage]!),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          currentPage = value;
          print(currentPage);
        }),
        currentIndex: currentPage,
        backgroundColor: Theme.of(context).colorScheme.background,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.view_agenda), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Now"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
