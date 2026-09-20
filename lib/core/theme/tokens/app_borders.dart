import 'package:flutter/material.dart';

abstract final class AppBorders {
  AppBorders._();


  static const BorderRadius xs = BorderRadius.all(Radius.circular(6));

  static const BorderRadius sm = BorderRadius.all(Radius.circular(10));

  static const BorderRadius md = BorderRadius.all(Radius.circular(14));

  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));

  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));

  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  static const BorderRadius bottomSheet =
      BorderRadius.vertical(top: Radius.circular(28));


  static const BorderRadius input = md;
  static const BorderRadius button = BorderRadius.all(Radius.circular(16));
  static const BorderRadius card = lg;
  static const BorderRadius chip = full;
  static const BorderRadius dialog = xl;


  static const RoundedRectangleBorder shapeSm =
      RoundedRectangleBorder(borderRadius: sm);
  static const RoundedRectangleBorder shapeMd =
      RoundedRectangleBorder(borderRadius: md);
  static const RoundedRectangleBorder shapeLg =
      RoundedRectangleBorder(borderRadius: lg);
  static const StadiumBorder stadium = StadiumBorder();
}
