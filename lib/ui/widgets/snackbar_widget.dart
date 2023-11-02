import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

snackbar (BuildContext context, String text){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: GoogleFonts.rambla(color: Colors.white,fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.purpleAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        duration: const Duration(milliseconds: 2000),
        behavior: SnackBarBehavior.floating,
      )
  );
}