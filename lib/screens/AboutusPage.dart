import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';

class AboutusPage extends StatelessWidget {
  final String back = 'assets/svgs/back.svg';

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return SafeArea(
        child: Scaffold(
      backgroundColor: COLOR_BACK_GROUND,
      appBar: AppBar(
        backgroundColor: COLOR_BACK_GROUND,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: LimitedBox(
            child: SvgPicture.asset(
              back,
              color: Colors.black,
              width: 40,
              height: 40,
              theme: SvgTheme(currentColor: null, fontSize: 12, xHeight: 6),
            ),
            maxHeight: 40,
            maxWidth: 40,
          ),
        ),
      ),
      body: Column(children: [
        Image.asset('assets/images/logo_tuli.png'),
        addVerticalSpace(20),
        const Text(
          "Tulibumu App",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: COLOR_BLACK,
          ),
        ),
        addVerticalSpace(40),
        Center(
          child: Text(
            "Tulibumu App is one used to monitor the daily activities of the tulibumu circle including loans offered",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: COLOR_BLACK,
            ),
          ),
        ),
        Center(
          child: Text(
            "Developed by Muwonge Khalifan, Email: khalifanmuwonge@gmail.com, Phone: 0706081432 ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: COLOR_BLACK,
            ),
          ),
        )
      ]),
    ));
  }
}
