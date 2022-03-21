import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tulibumu/screens/Landingpage.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginScreen> {
  TextEditingController _pass = TextEditingController();
  TextEditingController _contact = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final String back = 'assets/svgs/back.svg';
  bool isLoading = false;

  Future<void> SetUser(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data["token"]);
    prefs.setString('fullName', data["fullName"]);
    prefs.setString('role', data["role"]);
    prefs.setString('id', data["id"]);
  }

  Future<void> SignInUser(
      String memail, String mpassword, BuildContext context) async {
    String url = '$BaseUrl/api/users/login';
    setState(() {
      isLoading = true;
    });

    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <String, dynamic>{"contact": memail, "password": mpassword}),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 200) {
        //print("ACCEPTED" + statusCode.toString());
        // track transation message
        showText("Tusanyuse okulaba ;-)");

        SetUser(parsed["data"]).then((value) => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LandingPage())));

        setState(() {
          isLoading = false;
        });
      } else if (statusCode != 200) {
        showText('login failed:' + " " + parsed["message"]);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void showText(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
          child: Scaffold(
              backgroundColor: COLOR_BACK_GROUND,
              appBar: AppBar(
                backgroundColor: COLOR_BACK_GROUND,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: GestureDetector(
                  // onTap: () => Navigator.of(context).pop(),
                  child: LimitedBox(
                    child: SvgPicture.asset(
                      back,
                      color: Colors.black,
                      width: 40,
                      height: 40,
                      theme: SvgTheme(
                          currentColor: null, fontSize: 12, xHeight: 6),
                    ),
                    maxHeight: 40,
                    maxWidth: 40,
                  ),
                ),
              ),
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  addVerticalSpace(30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: const Text(
                      'Log in',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                          color: Colors.black,
                          fontFamily: "Comfortaa"),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            addVerticalSpace(20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Contact',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "* Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _contact,
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      hintText: "0702734902",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      filled: true),
                                ),
                              ],
                            ),
                            addVerticalSpace(20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Password',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                    controller: _pass,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "* Required";
                                      } else if (value.length < 6) {
                                        return "Password should be atleast 6 characters";
                                      } else {
                                        return null;
                                      }
                                    },
                                    // onSaved: (String password) {
                                    // this._password = password;
                                    //},
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        hintText: "***********",
                                        hintStyle: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                        filled: true)),
                              ],
                            ),
                            addVerticalSpace(20),
                            isLoading
                                ? CircularProgressIndicator(
                                    strokeWidth: 5,
                                    backgroundColor: Colors.blueGrey,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.yellow),
                                  )
                                : Column(
                                    children: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            minimumSize: const Size(350, 50),
                                            backgroundColor: Colors.blueGrey),
                                        onPressed: () {
                                          if (formkey.currentState!
                                              .validate()) {
                                            // login
                                            SignInUser(_contact.text,
                                                _pass.text, context);
                                          } else {
                                            showText(
                                                "Fill the fields correctly");
                                          }
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 20, color: COLOR_WHITE),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        )),
                  ),
                ],
              )))),
    );
  }

  @override
  void dispose() {
    _pass.dispose();

    super.dispose();
  }
}
