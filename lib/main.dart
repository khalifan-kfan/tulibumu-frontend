import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulibumu/screens/LandingPage.dart';
import 'package:tulibumu/screens/LoginScreen.dart';
import 'package:tulibumu/screens/SplashScreen.dart';
import 'package:tulibumu/utils/constants.dart';
import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  bool? isLogged_in;

  @override
  void initState() {
    // getState();
    super.initState();
  }

  Future<void> getState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token') ?? "";

    if (_token!.isEmpty) {
      setState(() {
        isLogged_in = false;
      });
    } else if (_token.toString().isNotEmpty) {
      setState(() {
        isLogged_in = true;
      });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    getState();
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
      home: isLogged_in == null
          ? SplashScreen()
          : isLogged_in == true
              ? const LandingPage()
              : const LoginScreen(),
    );
  }
}
