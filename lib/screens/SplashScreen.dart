import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: COLOR_BACK_GROUND,
      body: Center(
          child: const Text(
        "Tulibumu App",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: COLOR_BLACK,
        ),
      )),
    ));
  }
}
