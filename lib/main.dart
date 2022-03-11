import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulibumu/screens/LandingPage.dart';
import 'package:tulibumu/screens/LoginScreen.dart';
import 'package:tulibumu/utils/constants.dart';
import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<int> getState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token');
    if (_token == null) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    double screenWidth = window.physicalSize.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tulibumu',
      theme: ThemeData(
          primaryColor: COLOR_WHITE,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: COLOR_DARK_BLUE, // Your accent color
          ),
          textTheme: screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
          fontFamily: "Montserrat"),
      home: getState == 1 ? const LoginScreen() : const LandingPage(),
    );
  }
}
