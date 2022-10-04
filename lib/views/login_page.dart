import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/api/auth_api.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: state == LoginState.waiting
                            ? const Center(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: CircularProgressIndicator()))
                            : (state == LoginState.waitingForEmail
                                ? Consumer<AuthProvider>(
                                    builder: (context, provider, child) =>
                                        _EmailInput(callback: (isAdmin) async {
                                          // await provider.logout();
                                          if (isAdmin) {
                                            provider.loginWithPassword();
                                          } else {
                                            provider.login();
                                          }
                                        }))
                                : Consumer<AuthProvider>(
                                    builder: ((context, provider, child) => _CodeInput(
                                          callback: (code) async {
                                            setState(() {
                                              state = LoginState.waiting;
                                            });
                                            final authenticated =
                                                await AuthApi().submitCode(code, token!);
                                            if (authenticated) {
                                              setState(() {
                                                state = LoginState.success;
                                              });
                                            } else {
                                              setState(() {
                                                state = LoginState.waitingForCode;
                                              });
                                            }
                                          },
                                        ))))),
                  ]))),
    ));
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({required this.callback});
  final void Function(bool) callback;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "To get started, we need to verify you. Please use your University email address!",
              style: GoogleFonts.openSans(),
              textAlign: TextAlign.center,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            onPressed: () => callback(false),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(
              "Staff/Student Login",
              style: GoogleFonts.openSans(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(),
          child: TextButton(
            onPressed: () => callback(true),
            child: Text(
              "Admin Login",
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
