import 'package:flutter/material.dart';
import 'package:tulibumu/utils/constants.dart';

import 'package:tulibumu/utils/widget_functions.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: COLOR_BACK_GROUND,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_tuli.png'),
          addVerticalSpace(45),
          Text(
            "Tulibumu App",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: COLOR_BLACK,
            ),
          ),
        ],
      )),
    ));
  }
}
