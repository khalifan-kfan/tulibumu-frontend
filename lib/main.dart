import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    const storage = FlutterSecureStorage();
    var _token = await storage.read(key: "token");
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
      home: getState == 1 ? const LandingPage() : const LoginScreen(),
    );
  }
}
