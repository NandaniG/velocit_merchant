import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit_merchant/utils/styles.dart';
class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);

    /*   ////use in UI out side build in define
    ValueNotifier<bool> _obsecurepass = ValueNotifier<bool>(true);

    //make widget
    ValueListenableBuilder(
        valueListenable: _obsecurepass,
        builder: (context, value, child) {
          return TextFormField(
            obscureText: _obsecurepass.value,
          );
          // for ontap eye icon use _obsecurepass!=_obsecurepass;
        });*/
  }

  static errorToast(
      String msg,
      ) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1000,
        backgroundColor: Colors.red,
        fontSize: 20,
        textColor: Colors.white);
  }

  static successToast(
      String msg,
      ) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10000 * 5,
        fontSize: 20,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(15),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: ThemeApp.innerTextFieldErrorColor,
          reverseAnimationCurve: Curves.easeInOut,
          positionOffset: 20,
          borderRadius: BorderRadius.circular(8),
          icon: Icon(Icons.error, color: ThemeApp.whiteColor),
          message: message,
          duration: Duration(seconds: 3),
        )..show(context));
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ThemeApp.innerTextFieldErrorColor,
        content: Text(message)));
  }
}
class Prefs {
  //set Preferences
  Prefs._privateConstructor();

  static final Prefs instance = Prefs._privateConstructor();
  Future<void> setDoubleToken(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

//get Preferences
  Future<double?> getDoubleToken(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    double? Key;
    Key = pref.getDouble(key) ?? 0.0;
    return Key;
  }
//get Preferences
  clear() async {
     SharedPreferences pref = await SharedPreferences.getInstance();
   pref.clear();
  }
  //set Preferences
  Future<void> setToken(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

//get Preferences
  Future<String?> getToken(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? Key;
    Key = pref.getString(key) ?? '';
    return Key;
  }


  //set Preferences
  Future<void> setTokenList(String key, List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

//get Preferences
  Future<List<String>> getTokenList(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? Key;
    Key = pref.getStringList(key) ?? [];
    return Key;
  }

  getRupeesString(String value) {
    return Text("${'\u20A8' +value}");
  }


}
TextStyle SafeGoogleFont(
    String fontFamily, {
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    }) {
  try {
    return GoogleFonts.getFont(
      fontFamily,
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  } catch (ex) {
    return GoogleFonts.getFont(
      "Source Sans Pro",
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }
}