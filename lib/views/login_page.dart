import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LoginState {
  waitingForEmail,
  waitingForCode,
  success,
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginState state = LoginState.waitingForEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Welcome to Lab Monitor",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ))),
              if (state == LoginState.waitingForEmail) _EmailInput(),
              if (state == LoginState.waitingForCode) _CodeInput(),
            ],
          )),
    )));
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "To get started, we need to verify you. Enter your University email below.",
              style: GoogleFonts.openSans(),
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  hintText: "username@nottingham.ac.uk"),
            )),
      ],
    );
  }
}

class _CodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Enter the code we just emailed you. Make sure to check your spam or junk folders.",
              style: GoogleFonts.openSans(),
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Container())
      ],
    );
  }
}
