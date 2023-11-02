import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDecoration(String text){
  return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Colors.purple,
              style: BorderStyle.solid)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.purple,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15)
      ),
      hoverColor: Colors.purple,
      labelText: text,
      labelStyle: GoogleFonts.rambla(
          color: Colors.purpleAccent, fontSize: 20)
  );
}