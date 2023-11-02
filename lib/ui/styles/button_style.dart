import 'package:flutter/material.dart';

ButtonStyle buttonStyle(){
  return ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      minimumSize: const Size(200, 50),
      shadowColor: Colors.orange,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15))
  );
}

ButtonStyle buttonMainStyle(){
  return ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      minimumSize: const Size(260, 50),
      shadowColor: Colors.orange,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15))
  );
}