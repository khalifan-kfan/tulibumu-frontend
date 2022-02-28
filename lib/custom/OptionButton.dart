import 'package:flutter/material.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;
  OptionButton(
      {Key? key, required this.text, required this.icon, required this.width})
      : super(key: key) {
    throw UnimplementedError();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextButton(
          style: TextButton.styleFrom(
            primary: COLOR_DARK_BLUE,
            onSurface: Colors.white.withAlpha(55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: COLOR_WHITE,
              ),
              addHorizontalSpace(10),
              Text(
                text,
                style: TextStyle(color: COLOR_WHITE),
              )
            ],
          )),
    );
  }
}