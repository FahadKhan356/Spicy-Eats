import 'package:flutter/material.dart';

class Responsive {
//HEIGHT

  static late double h95px;
  static late double h36px;
  static late double h20px;
  static late double h50px;
  static late double h100px;

//WIDTH

  static late double w14px;
  static late double w10px;
  static late double w20px;
  static late double w80px;
  static late double w28px;
  static late double w16px;
  static late double w8px;
  static late double w12px;
  static late double w25px;
  static late double w40px;
  static late double h70px;
  static late double w30px;
  static late double w18px;

//WIDTH-PADDING

  static late double w6px;
  static late double w4px;
  static late double w5px;

  static void init(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    //HEIGHT
    h95px = screen.height * 0.13;
    h36px = screen.height * 0.05;
    h20px = screen.height * 0.027;
    h50px = screen.height * 0.07;
    h100px = screen.height * 0.138;
    h70px = screen.height * 0.095;

    //HEIGHT-PADDING

    //WIDTH
    w14px = screen.width * 0.036;
    w10px = screen.width * 0.025;
    w20px = screen.width * 0.05;
    w80px = screen.width * 0.2;
    w28px = screen.width * 0.07;
    w12px = screen.width * 0.029;
    w16px = screen.width * 0.03;
    w4px = screen.width * 0.01;
    w25px = screen.width * 0.06;
    w40px = screen.width * 0.097;
    w8px = screen.width * 0.02;
    w30px = screen.width * 0.075;
    w18px = screen.width * 0.045;
    w5px = screen.width * 0.012;

    //WIDTH-PADDING
    w6px = screen.width * 0.015;
  }
}
