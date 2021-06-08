import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtils {
  static Future<T> toScreen<T extends Object>(
      BuildContext context, {
        @required Widget screen,
      }) async {
    return Navigator.push<T>(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  static Future<T> toScreenRemoveUntil<T extends Object>(
      BuildContext context, {
        @required Widget screen,
      }) async {
    return Navigator.pushAndRemoveUntil<T>(
        context, MaterialPageRoute(builder: (_) => screen), (route) => false);
  }
}