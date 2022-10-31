import 'dart:ui';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final key = prefix0.Key.fromLength(32);
final iv = IV.fromLength(16);
final encrypter = Encrypter(AES(key));

String encrypt(String plainText) {
  if(plainText.isEmpty) {
    return "";
  }
  try {
    return encrypter.encrypt(plainText, iv: iv).base64;
  } catch(e){}
  return plainText;
}

void showToastSuccess(String msg, { int delay = 1 }) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIosWeb: delay,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Color(0xFFEBFAF5),
    textColor: Color(0xFF00C17C),
    fontSize: 16.0,
  );
}

void showToastError(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: const Color(0xFFFDF8EF),
    textColor: const Color(0xFFEBAD34),
    fontSize: 16.0,
  );
}

void showToastWarning(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.yellow[200],
    textColor: Color(0xFF2183DF),
    fontSize: 16.0,
  );
}

void showToastInfo(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Color(0xFFE4F0FB),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}