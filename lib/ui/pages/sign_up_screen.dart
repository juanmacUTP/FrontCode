// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s_distribuidos/controller/connection_controller.dart';
import 'package:s_distribuidos/ui/pages/sign_in_screen.dart';
import 'package:s_distribuidos/ui/widgets/snackbar_widget.dart';
import '../styles/button_style.dart';
import '../styles/input_decoration.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late bool _obscureText;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  List<TextEditingController> textControllers = [];

  void createList() {
    textControllers = [
      _idController,
      _nameController,
      _phoneController,
      _addressController,
      _occupationController,
      _passController
    ];
  }

  bool areFieldsNotEmpty() {
    return textControllers.every((controller) => controller.text.isNotEmpty);
  }

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
          if (constraints.maxWidth > 600) {
            return _signUpBody();
          } else {
            return _signUpMobileBody();
          }
        },
      ),
    );
  }

  Widget _signUpMobileBody() {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Sign Up",
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
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Phone'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _addressController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Address'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _occupationController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Occupation'),
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
                          if (areFieldsNotEmpty()) {
                            int response = await ConnectionController.signUp(
                                _nameController.text,
                                _idController.text,
                                _passController.text,
                                _phoneController.text,
                                _addressController.text,
                                _occupationController.text);
                            if (response == 201) {
                              snackbar(
                                  context, 'User registered successfully!');
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
                                        child: const SignInPage(),
                                      );
                                    }),
                                (route) => false,
                              );
                            } else {
                              snackbar(context,
                                  'An error has occurred ${response.toString()}');
                            }
                          } else {
                            snackbar(context, 'One or more fields are empty!');
                          }
                        },
                        style: buttonStyle(),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.rambla(shadows: [
                            const BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0.0,
                                blurRadius: 10)
                          ], color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signUpBody() {
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
                width: 800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Sign Up",
                          style: GoogleFonts.rambla(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: _idController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.purple,
                              style:
                                  const TextStyle(color: Colors.purpleAccent),
                              decoration: inputDecoration('Id'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: _nameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.purple,
                              style:
                                  const TextStyle(color: Colors.purpleAccent),
                              decoration: inputDecoration('Name'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.purple,
                              style:
                                  const TextStyle(color: Colors.purpleAccent),
                              decoration: inputDecoration('Phone'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: _addressController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.purple,
                              style:
                                  const TextStyle(color: Colors.purpleAccent),
                              decoration: inputDecoration('Address'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: _occupationController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.purple,
                              style:
                                  const TextStyle(color: Colors.purpleAccent),
                              decoration: inputDecoration('Occupation'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              controller: _passController,
                              obscureText: _obscureText,
                              cursorColor: Colors.purple,
                              style:
                                  const TextStyle(color: Colors.purpleAccent),
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
                                      color: Colors.purpleAccent,
                                      fontSize: 20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (areFieldsNotEmpty()) {
                            int response = await ConnectionController.signUp(
                                _nameController.text,
                                _idController.text,
                                _passController.text,
                                _phoneController.text,
                                _addressController.text,
                                _occupationController.text);
                            if (response == 201) {
                              snackbar(
                                  context, 'User registered successfully!');
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
                                        child: const SignInPage(),
                                      );
                                    }),
                                (route) => false,
                              );
                            } else {
                              snackbar(context,
                                  'An error has occurred ${response.toString()}');
                            }
                          } else {
                            snackbar(context, 'One or more fields are empty!');
                          }
                        },
                        style: buttonStyle(),
                        child: Text(
                          'Sign Up',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
