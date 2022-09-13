import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/api/auth_api.dart';
import 'package:lab_availability_checker/providers/token_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginState {
  waitingForEmail,
  waiting,
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
  String? token;
  String? email;
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
              if (state == LoginState.waitingForEmail)
                _EmailInput(callback: (_email) async {
                  setState(() {
                    state = LoginState.waiting;
                  });
                  final _token = await AuthApi().submitEmail(_email);
                  if (_token != null) {
                    setState(() {
                      email = _email;
                      token = _token;
                      state = LoginState.waitingForCode;
                    });
                  }
                }),
              if (state == LoginState.waitingForCode)
                Consumer<TokenProvider>(
                    builder: ((context, provider, child) => _CodeInput(
                          callback: (code) async {
                            setState(() {
                              state = LoginState.waiting;
                            });
                            final authenticated = await AuthApi().submitCode(code, token!);
                            if (authenticated) {
                              await provider.setToken(token!, email!);
                              setState(() {
                                state = LoginState.success;
                              });
                            } else {
                              setState(() {
                                state = LoginState.waitingForCode;
                              });
                            }
                          },
                        ))),
              if (state == LoginState.waiting)
                const Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator()))
            ],
          )),
    )));
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({required this.callback});
  final void Function(String) callback;
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
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
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  hintText: "username@nottingham.ac.uk"),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
            onPressed: () => callback(emailController.text),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(
              "Submit",
              style: GoogleFonts.openSans(),
            ),
          ),
        )
      ],
    );
  }
}

class _CodeInput extends StatefulWidget {
  const _CodeInput({required this.callback});
  final void Function(String) callback;

  @override
  createState() => _CodeInputState();
}

class _CodeInputState extends State<_CodeInput> {
  bool _onEditing = true;
  String _code = "";
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "It may take up to 15 minutes to receive the email, so please be patient. You have 30 minutes to enter the code.",
              style: GoogleFonts.openSans(),
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: VerificationCode(
                  onEditing: (bool value) {
                    setState(() {
                      _onEditing = value;
                    });
                    if (!_onEditing) FocusScope.of(context).unfocus();
                  },
                  onCompleted: (value) {
                    _code = value;
                    _onEditing = false;
                    widget.callback(value);
                  },
                  underlineColor: Theme.of(context).colorScheme.onSurface,
                  underlineUnfocusedColor: Theme.of(context).colorScheme.onSurface,
                  fullBorder: true,
                  textStyle: GoogleFonts.openSans(fontSize: 16),
                  keyboardType: TextInputType.number,
                  length: 6,
                ))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
            onPressed: () => _code.length == 6 ? widget.callback(_code) : {},
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(
              "Submit",
              style: GoogleFonts.openSans(),
            ),
          ),
        )
      ],
    );
  }
}
