// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s_distribuidos/controller/connection_controller.dart';
import 'package:s_distribuidos/ui/pages/home_screen.dart';
import 'package:s_distribuidos/ui/pages/sign_up_screen.dart';
import 'package:s_distribuidos/ui/widgets/snackbar_widget.dart';
import '../styles/button_style.dart';
import '../styles/input_decoration.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late bool _obscureText;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    _obscureText = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 700) {
            return _signInBody();
          } else {
            return _signInMobileBody();
          }
        },
      ),
    );
  }

  Widget _signInMobileBody() {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 140,
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Sign In",
                          style: GoogleFonts.rambla(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _idController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Id'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _passController,
                        obscureText: _obscureText,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: InputDecoration(
                            suffixIcon: CupertinoButton(
                              child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.purple),
                              onPressed: () {
                                _obscureText = !_obscureText;
                                setState(() {});
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Colors.purple,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.purple,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.rambla(
                                color: Colors.purpleAccent, fontSize: 20)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final FocusScopeNode focus = FocusScope.of(context);
                          if (!focus.hasPrimaryFocus && focus.hasFocus) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                          if (_idController.text.isNotEmpty &&
                              _passController.text.isNotEmpty) {
                            int response = await ConnectionController.signIn(
                                _idController.text, _passController.text);
                            if (response == 200) {
                              snackbar(context, 'Welcome Back!');
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: const HomePage(),
                                      );
                                    }),
                                (route) => false,
                              );
                            } else if (response == 401){
                              snackbar(context, 'Incorrect Id or Password, try again');
                            }else {
                              snackbar(context,
                                  'An error has occurred: ${response.toString()}!');
                            }
                          } else {
                            snackbar(context, 'the fields are empty');
                          }
                        },
                        style: buttonStyle(),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.rambla(shadows: [
                            const BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0.0,
                                blurRadius: 10)
                          ], color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Center(
                          child: Text(
                            'Don\'t have an account?',
                            style: GoogleFonts.asap(shadows: [
                              const BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.0,
                                  blurRadius: 10)
                            ], color: Colors.purple, fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: const SignUpPage(),
                                      );
                                    }));
                          },
                          style: buttonStyle(),
                          child: Text(
                            'Sing Up',
                            style: GoogleFonts.rambla(shadows: [
                              const BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.0,
                                  blurRadius: 3)
                            ], color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInBody() {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                width: 600,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Sign In",
                          style: GoogleFonts.rambla(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _idController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Id'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _passController,
                        obscureText: _obscureText,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            suffixIcon: CupertinoButton(
                              child: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.purple),
                              onPressed: () {
                                _obscureText = !_obscureText;
                                setState(() {});
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Colors.purple,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.purple,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.rambla(
                                color: Colors.purpleAccent, fontSize: 20)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_idController.text.isNotEmpty &&
                              _passController.text.isNotEmpty) {
                            int response = await ConnectionController.signIn(
                                _idController.text, _passController.text);
                            if (response == 200) {
                              snackbar(context, 'Welcome Back!');
                              Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: const HomePage(),
                                      );
                                    }),
                                (route) => false,
                              );
                            } else {
                              snackbar(context,
                                  'An error has occurred: ${response.toString()}!');
                            }
                          } else {
                            snackbar(context, 'the fields are empty');
                          }
                        },
                        /* onPressed: (){
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                                transitionDuration:
                                const Duration(milliseconds: 500),
                                reverseTransitionDuration:
                                const Duration(milliseconds: 300),
                                pageBuilder: (context, animation, _) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: const HomePage(),
                                  );
                                }),
                                (route) => false,
                          );
                        },*/
                        style: buttonStyle(),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.rambla(shadows: [
                            const BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0.0,
                                blurRadius: 10)
                          ], color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Center(
                          child: Text(
                            'Don\'t have an account?',
                            style: GoogleFonts.asap(shadows: [
                              const BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.0,
                                  blurRadius: 10)
                            ], color: Colors.purple, fontSize: 12),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: const SignUpPage(),
                                      );
                                    }));
                          },
                          style: buttonStyle(),
                          child: Text(
                            'Sing Up',
                            style: GoogleFonts.rambla(shadows: [
                              const BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.0,
                                  blurRadius: 3)
                            ], color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
