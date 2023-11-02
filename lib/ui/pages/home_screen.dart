import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s_distribuidos/controller/connection_controller.dart';
import 'package:s_distribuidos/controller/user_controller.dart';
import 'package:s_distribuidos/ui/pages/sign_in_screen.dart';
import 'package:s_distribuidos/ui/pages/update_screen.dart';
import 'package:s_distribuidos/ui/styles/input_decoration.dart';
import 'package:s_distribuidos/ui/styles/table_styles.dart';
import 'package:s_distribuidos/ui/widgets/snackbar_widget.dart';
import '../../model/user_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../widgets/show_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DataRow> _rows = [];
  List<UserModel> users = [];
  late int connectionCode;
  final TextEditingController _searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rows.clear();
    users.clear();
    UserController.cleanUserList();
    getUsers();
  }

  void getUsers() async {
    UserController.addUsersFromDB().then((value) {
      if (value == 200) {
        users = UserController.usersList;
        buildRows();
      } else if (value == -1) {
        snackbar(context, 'maximum downtime is over, sign in again');
        _logOut();
      } else {
        snackbar(context, 'An error has occurred: $value');
      }
    });
  }

  void buildRows() {
    _rows = [];
    _rows = users.map((user) {
      return DataRow(cells: [
        DataCell(Text(user.userId, style: rowStyle)),
        DataCell(Text(user.userName, style: rowStyle)),
        DataCell(Center(child: Text(user.userOccupation, style: rowStyle))),
        DataCell(Text(user.userAddress, style: rowStyle)),
        DataCell(Text(user.userPhone, style: rowStyle)),
        DataCell(
            const Center(
                child: Icon(
              Icons.edit,
              color: Colors.purpleAccent,
              weight: 10,
            )), onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                reverseTransitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, _) {
                  return FadeTransition(
                    opacity: animation,
                    child: UpdatePage(user),
                  );
                }),
          );
        }),
        DataCell(
            const Center(
                child: Icon(
              Icons.delete,
              color: Colors.purpleAccent,
              weight: 10,
            )), onTap: () {
          deleteUser(context, user);
        }),
      ]);
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 700) {
            return _homeBody();
          } else {
            return _homeMobileBody();
          }
        },
      ),
      appBar: kIsWeb ? null : myAppbar(),
    );
  }

  Widget _homeBody() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 0,
                ),
                Text(
                  'Home',
                  style: GoogleFonts.rambla(color: Colors.purple, fontSize: 30),
                ),
                TextButton(
                  onPressed: () {
                    ConnectionController.deleteToken();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          reverseTransitionDuration:
                              const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child: const SignInPage(),
                            );
                          }),
                    );
                  },
                  child: Text(
                    'Log Out',
                    style:
                        GoogleFonts.rambla(color: Colors.purple, fontSize: 18),
                  ),
                )
              ],
            ),
            Container(
              width: 950,
              height: 500,
              margin: const EdgeInsets.symmetric(vertical: 30),
              //padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 241, 251, 50),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 3,
                      color: Colors.grey,
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.purpleAccent,
                    width: 0.5,
                    style: BorderStyle.solid,
                  )),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 150,
                          ),
                          SizedBox(
                            width: 560,
                            height: 55,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: TextFormField(
                                controller: _searchText,
                                decoration: inputDecoration('Search...'),
                                style:
                                    const TextStyle(color: Colors.purpleAccent),
                                autofillHints: const [
                                  AutofillHints.name,
                                  AutofillHints.jobTitle
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _rows.clear();
                                users.clear();
                                UserController.cleanUserList();
                                UserController.searchUserFromDB(
                                        _searchText.text)
                                    .then((value) {
                                  if (value == -1) {
                                    snackbar(context,
                                        'maximum downtime is over, sign in again');
                                    _logOut();
                                  } else if (value == 200) {
                                    users = UserController.usersList;
                                    buildRows();
                                  } else {
                                    snackbar(context,
                                        'An error has occurred: $value, try again later');
                                  }
                                });
                              },
                              child: const Icon(
                                Icons.search,
                                color: Colors.purple,
                                weight: 25,
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                              onPressed: () => _refreshPage(),
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.purple,
                                weight: 25,
                              ))
                        ],
                      )),
                  _rows.isEmpty
                      ? const Center(
                          heightFactor: 10,
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SingleChildScrollView(
                            child: DataTable(
                              columnSpacing: 30,
                              columns: <DataColumn>[
                                DataColumn(
                                    label: Align(
                                        alignment: Alignment.center,
                                        child: Text('Id', style: headerStyle))),
                                DataColumn(
                                    label: Center(
                                        child:
                                            Text('Name', style: headerStyle))),
                                DataColumn(
                                    label: Center(
                                        child: Text('Occupation',
                                            style: headerStyle))),
                                DataColumn(
                                    label: Center(
                                        child: Text('Address',
                                            style: headerStyle))),
                                DataColumn(
                                    label: Center(
                                        child:
                                            Text('Phone', style: headerStyle))),
                                DataColumn(
                                    label: Center(
                                        child: Text('Update',
                                            style: headerStyle))),
                                DataColumn(
                                    label: Center(
                                        child: Text('Delete',
                                            style: headerStyle))),
                              ],
                              rows: _rows,
                            ),
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _homeMobileBody() {
    return GestureDetector(
      onTap: (){
        final FocusScopeNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Column(
        children: [
          Row(
              children: [
                const SizedBox(
                  width: 25,
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: TextFormField(
                      controller: _searchText,
                      decoration: inputDecoration('Search...'),
                      style:
                      const TextStyle(color: Colors.purpleAccent),
                      autofillHints: const [
                        AutofillHints.name,
                        AutofillHints.jobTitle
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _rows.clear();
                      users.clear();
                      UserController.cleanUserList();
                      UserController.searchUserFromDB(
                          _searchText.text)
                          .then((value) {
                        if (value == -1) {
                          snackbar(context,
                              'maximum downtime is over, sign in again');
                          _logOut();
                        } else if (value == 200) {
                          users = UserController.usersList;
                          buildRows();
                          _searchText.clear();
                          final FocusScopeNode focus = FocusScope.of(context);
                          if (!focus.hasPrimaryFocus && focus.hasFocus) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        } else {
                          snackbar(context,
                              'An error has occurred: $value, try again later');
                        }
                      });
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.purple,
                      weight: 15,
                    )),
              ],
            ),
          users.isEmpty
              ? const Center(
                  heightFactor: 15,
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _buildRow(users[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildRow(UserModel user) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, _) {
                return FadeTransition(
                  opacity: animation,
                  child: UpdatePage(user),
                );
              }),
          (route) => false,
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.purple, blurRadius: 5, spreadRadius: 1)
            ]),
        child: ListTile(
          title: Text(user.userName),
          subtitle: Text(user.userId),
          leading: const Icon(
            Icons.account_circle_outlined,
            color: Colors.purple,
            size: 45,
          ),
          trailing:
              const Icon(Icons.arrow_right, color: Colors.purple, size: 45),
        ),
      ),
    );
  }

  _refreshPage() {
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
  }

  _logOut() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: const SignInPage(),
            );
          }),
      (route) => false,
    );
  }

  _handleTap(int item) {
    switch (item) {
      case 0:
        _refreshPage();
        break;
      case 1:
        _logOut();
        break;
    }
  }

  PreferredSizeWidget myAppbar() {
    return AppBar(
      backgroundColor: Colors.purple,
      title: Text(
        'Home',
        style: GoogleFonts.rambla(color: Colors.white, fontSize: 20),
      ),
      actions: <Widget>[
        PopupMenuButton<int>(
            color: Colors.white,
            onSelected: (item) => _handleTap(item),
            itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 0,
                      child: Text('Refresh',
                          style: GoogleFonts.rambla(
                              color: Colors.purple, fontSize: 20))),
                  PopupMenuItem(
                      value: 1,
                      child: Text('Log Out',
                          style: GoogleFonts.rambla(
                              color: Colors.purple, fontSize: 20)))
                ]),
      ],
      centerTitle: true,
    );
  }
}
