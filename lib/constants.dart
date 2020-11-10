import 'package:flutter/material.dart';

BoxDecoration kBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFEFE33A), Color(0xFFF77800)],
      stops: [0.15, 0.9],
    )
);

InputDecoration textFieldDecoration = InputDecoration(
  hintText: 'Enter Value',
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.blue),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
  ),
);

enum UserType{
  guest,
  user,
  admin
}

int numberOfImagesInGallery = 9;