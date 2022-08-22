import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:lab_availability_checker/views/now_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UoN Lab Monitor',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: const MaterialColor(0xFF133769, <int, Color>{
          50: Color.fromRGBO(19, 55, 105, 0.1),
          100: Color.fromRGBO(19, 55, 105, 0.2),
          200: Color.fromRGBO(19, 55, 105, 0.3),
          300: Color.fromRGBO(19, 55, 105, 0.4),
          400: Color.fromRGBO(19, 55, 105, 0.5),
          500: Color.fromRGBO(19, 55, 105, 0.6),
          600: Color.fromRGBO(19, 55, 105, 0.7),
          700: Color.fromRGBO(19, 55, 105, 0.8),
          800: Color.fromRGBO(19, 55, 105, 0.9),
          900: Color.fromRGBO(19, 55, 105, 1),
        }),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
    NowView(),
    Container(),
  ];
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 0,
      //   systemOverlayStyle: SystemUiOverlayStyle.dark,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: SafeArea(top: false, child: states[currentPage]!),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          currentPage = value;
          print(currentPage);
        }),
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.view_agenda), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Now"),
          BottomNavigationBarItem(icon: Icon(Icons.room), label: "Rooms"),
        ],
      ),
    );
  }
}
