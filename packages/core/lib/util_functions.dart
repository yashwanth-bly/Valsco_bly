import 'package:flutter/material.dart';

class UtilFunctions {
  static bool isMobileValid(String mobile) {
    //Regex pattern for matching only alphabets and white spaces:
    String pattern = r"^[6-9]\d{9}$";

/*
    ^     #Match the beginning of the string
    [6-9] #Match a 6, 7, 8 or 9
    \d    #Match a digit (0-9 and anything else that is a "digit" in the regex engine)
    {9}   #Repeat the previous "\d" 9 times (9 digits)
    $     #Match the end of the string
*/

    RegExp regex = RegExp(pattern);
    if (mobile.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(mobile)) {
        return false;
      } else {
        return true;
      }
    }
  }

  static bool isEmailValid(String email) {
    //Regex pattern for matching email
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (email.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(email)) {
        return false;
      } else {
        return true;
      }
    }
  }

  static bool isNameValid(String name) {
    //Regex pattern for matching only alphabets and white spaces:
    String pattern = r"^[a-zA-Z]+[\-'\s]?[a-zA-Z ]+$";
    RegExp regex = RegExp(pattern);
    if (name.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(name)) {
        return false;
      } else {
        return true;
      }
    }
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  static void showInSnackBar(BuildContext context, String value,
      {int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
