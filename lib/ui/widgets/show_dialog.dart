import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s_distribuidos/controller/connection_controller.dart';
import 'package:s_distribuidos/model/user_model.dart';
import 'package:s_distribuidos/ui/pages/home_screen.dart';
import 'package:s_distribuidos/ui/pages/sign_in_screen.dart';
import 'package:s_distribuidos/ui/widgets/snackbar_widget.dart';

void deleteUser(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete User', style: GoogleFonts.rambla(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold),),
        content: Text('Are you sure to delete to ${user.userName}?', style: GoogleFonts.rambla(color: Colors.purple, fontSize: 18),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: GoogleFonts.rambla(color: Colors.purple, fontSize: 18),),
          ),
          TextButton(
            onPressed: () async {
              ConnectionController.deleteUser(user).then((value){
                if (value == 200){
                  snackbar(context, 'User deleted successfully');
                  Navigator.pushAndRemoveUntil(context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          reverseTransitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child: const HomePage(),
                            );
                          }), (route) => false);
                } else if(value == -1){
                  snackbar(context, 'maximum downtime is over, sign in again');
                  Navigator.pushAndRemoveUntil(context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          reverseTransitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child: const SignInPage(),
                            );
                          }), (route) => false);
                } else{
                  snackbar(context, 'An error has occurred: $value');
                  Navigator.of(context).pop();
                }
             });

            },
            child: Text('Delete', style: GoogleFonts.rambla(color: Colors.red, fontSize: 18),),
          ),
        ],
      );
    },
  );
}

void updateUser(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update User', style: GoogleFonts.rambla(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold),),
        content: Text('Are you sure to save this changes to ${user.userName}?', style: GoogleFonts.rambla(color: Colors.purple, fontSize: 18),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: GoogleFonts.rambla(color: Colors.purple, fontSize: 18),),
          ),
          TextButton(
            onPressed: () async {
              ConnectionController.updateUser(user).then((value){
                if (value == 200){
                  snackbar(context, 'User updated successfully');
                  Navigator.pushAndRemoveUntil(context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          reverseTransitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child: const HomePage(),
                            );
                          }), (route) => false);
                } else if(value == -1){
                  snackbar(context, 'maximum downtime is over, sign in again');
                  Navigator.pushAndRemoveUntil(context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 500),
                          reverseTransitionDuration: const Duration(milliseconds: 300),
                          pageBuilder: (context, animation, _) {
                            return FadeTransition(
                              opacity: animation,
                              child: const SignInPage(),
                            );
                          }), (route) => false);
                } else if(value == 404){
                  snackbar(context, 'you haven\'t made changes');
                  Navigator.of(context).pop();
                } else{
                  snackbar(context, 'An error has occurred: $value');
                  Navigator.of(context).pop();
                }
              });

            },
            child: Text('Update', style: GoogleFonts.rambla(color: Colors.red, fontSize: 18),),
          ),
        ],
      );
    },
  );
}