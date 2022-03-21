import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:tulibumu/screens/Landingpage.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordPage extends StatefulWidget {
  final dynamic MyUser;
  const ChangePasswordPage({Key? key, required this.MyUser}) : super(key: key);

  @override
  _ChangePasswordPage createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  TextEditingController new_pass = TextEditingController();
  TextEditingController old_pass = TextEditingController();
  TextEditingController conf_pass = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final String back = 'assets/svgs/back.svg';
  bool loading = false;
  String msg = "";

  Future<void> Reset(String new_p, String old_p, BuildContext context) async {
    String url = '$BaseUrl/api/users/resetpassword';
    setState(() {
      loading = true;
    });

    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "oldpassword": old_p,
        "password": new_p,
        "id": widget.MyUser!["id"]
      }),
    )
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 201) {
        //double
        showText("Password changed successfully");
        setState(() {
          loading = false;
        });
        Navigator.of(context).pop();
      } else if (statusCode != 201) {
        showText('Password change failed');
        setState(() {
          msg = "Something went wrong";
        });
        setState(() {
          loading = false;
        });
      }
    });
  }

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
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: LimitedBox(
                  child: SvgPicture.asset(
                    back,
                    color: Colors.black,
                    width: 40,
                    height: 40,
                    theme:
                        SvgTheme(currentColor: null, fontSize: 12, xHeight: 6),
                  ),
                  maxHeight: 40,
                  maxWidth: 40,
                ),
              ),
            ),
            body: Container(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  addVerticalSpace(30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: const Text(
                      'Change password',
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
                                  'Old password',
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
                                  controller: old_pass,
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      hintText: "secret",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      filled: true),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'New password',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                    controller: new_pass,
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Confirm Password',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                    controller: conf_pass,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "* Required";
                                      } else if (value != new_pass.text) {
                                        return "Password should be the same";
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
                            addVerticalSpace(5),
                            if (msg.isNotEmpty)
                              Text(
                                msg,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            addVerticalSpace(20),
                            if (loading)
                              Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  backgroundColor: Colors.blueGrey,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.yellow),
                                ),
                              )
                            else
                              Column(
                                children: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        minimumSize: const Size(350, 50),
                                        backgroundColor: Colors.blueGrey),
                                    onPressed: () {
                                      if (formkey.currentState!.validate()) {
                                        // login
                                        Reset(new_pass.text, old_pass.text,
                                            context);
                                      } else {
                                        showText("Fill the fields correctly");
                                      }
                                    },
                                    child: const Text(
                                      "Change Password",
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
              ),
            ))));
  }

  @override
  void dispose() {
    new_pass.dispose();
    conf_pass.dispose();
    super.dispose();
  }
}
