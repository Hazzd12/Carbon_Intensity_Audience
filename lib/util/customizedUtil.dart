import 'dart:async';
import 'package:flutter/material.dart';

Widget CustomizedText(String txt,
    {double font_size = 24.0, //Named Parameters
      Color font_color = Colors.white,
      FontWeight font_Weight = FontWeight.bold}) {
  return Text(txt,
      softWrap: true,
      style: TextStyle(
        fontSize: font_size,
        color: font_color,
        fontWeight: font_Weight,
      ));
}
