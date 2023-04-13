// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:flutter/material.dart';

class MyColors {

  Color blue = Color(0xff6C8BFA);
  Color turkis = Color(0xff1AC9BA);
  Color red = Color(0xffFF595B);
  Color green = Color(0xff47B84A);
  Color violett = Color(0xffE96CA0);
  Color grey = Color(0xffC6C6C6);
}

TextStyle entryTextStyle() {
  return TextStyle(
    fontSize: 18,
    color: Colors.black54,
    fontWeight: FontWeight.w400
  );
}

InputDecoration textFieldInputDecoration() {
  return InputDecoration(
    hintStyle: TextStyle(
      color: Colors.black,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black38)
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black38)
    ),
  );
}

InputDecoration textFieldInputDecorationWithHint(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.black38,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black38)
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black38)
    ),
  );
}