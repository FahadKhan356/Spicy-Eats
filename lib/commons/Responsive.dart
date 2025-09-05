import 'package:flutter/material.dart';

class Responsive {
//heights
  static late double h95px;
  static late double h36px;
  static late double h20px;
  static late double h50px;
  static late double h100px;

  

//widths

  static late double w14px;
  static late double w10px;
  static late double w20px;
  static late double w80px;
  static late double w28px;
  static late double w16px;
  static late double w8px;
  static late double w12px;


  //padding

  static late double w6px;

  static void init(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    //heights
    h95px = screen.height * 0.13;
    h36px = screen.height * 0.05;
    h20px = screen.height * 0.027;
    h50px = screen.height * 0.07;
    h100px = screen.height * 0.138;


    //width
    w14px = screen.width * 0.036;
    w10px = screen.width * 0.025;
    w20px = screen.width * 0.05;
    w80px = screen.width * 0.2;
    w28px = screen.width * 0.07;
    w12px = screen.width * 0.04;
    w16px = screen.width * 0.03;

    w8px = screen.width * 0.02;

    //padding
    w6px = screen.width * 0.015;
  }
}
