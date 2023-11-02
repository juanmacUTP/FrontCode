import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:s_distribuidos/model/user_model.dart';
import 'package:s_distribuidos/ui/pages/home_screen.dart';
import 'package:s_distribuidos/ui/widgets/show_dialog.dart';
import '../styles/button_style.dart';
import '../styles/input_decoration.dart';

class UpdatePage extends StatefulWidget {
  final UserModel _user;

  const UpdatePage(this._user, {super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  void initText() {
    _idController.text = widget._user.userId;
    _nameController.text = widget._user.userName;
    _phoneController.text = widget._user.userPhone;
    _addressController.text = widget._user.userAddress;
    _occupationController.text = widget._user.userOccupation;
  }

  @override
  void initState() {
    initText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 750) {
            return _updateBody();
          } else {
            return _updateMobileBody();
          }
        },
      ),
      appBar: kIsWeb ? null : _myAppBar(),
    );
  }

  _handleTap(int item) {
    switch (item) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, _) {
                return FadeTransition(
                  opacity: animation,
                  child: const HomePage(),
                );
              }),
          (route) => false,
        );
        break;
    }
  }

  PreferredSizeWidget _myAppBar() {
    return AppBar(
      backgroundColor: Colors.purple,
      title: Text(
        'Update',
        style: GoogleFonts.rambla(color: Colors.white, fontSize: 20),
      ),
      actions: <Widget>[
        PopupMenuButton<int>(
            color: Colors.white,
            onSelected: (item) => _handleTap(item),
            itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 0,
                      child: Text('Cancel',
                          style: GoogleFonts.rambla(
                              color: Colors.purple, fontSize: 20))),
                ]),
      ],
      centerTitle: true,
    );
  }

  Widget _updateMobileBody() {
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
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _idController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.purple,
                        style: const TextStyle(color: Colors.purpleAccent),
                        decoration: inputDecoration('Id'),
                        enabled: false,
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
                        enabled: false,
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
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          widget._user.userPhone = _phoneController.text;
                          widget._user.userOccupation = _occupationController.text;
                          widget._user.userAddress = _addressController.text;
                          updateUser(context, widget._user);
                        },
                        style: buttonStyle(),
                        child: Text(
                          'Update',
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
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          deleteUser(context, widget._user);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(200, 50),
                            shadowColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          'Delete',
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

  Widget _updateBody() {
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
                      child: Text("Update User",
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
                              enabled: false,
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
                              enabled: false,
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
                    Row(children: [
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
                            style: const TextStyle(color: Colors.purpleAccent),
                            decoration: inputDecoration('Occupation'),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          widget._user.userPhone = _phoneController.text;
                          widget._user.userOccupation = _occupationController.text;
                          widget._user.userAddress = _addressController.text;
                          updateUser(context, widget._user);
                        },
                        style: buttonStyle(),
                        child: Text(
                          'Update',
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
            ),
          ],
        ),
      ),
    );
  }
}
