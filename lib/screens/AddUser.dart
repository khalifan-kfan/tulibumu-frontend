import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:tulibumu/screens/Landingpage.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUser createState() => _AddUser();
}

class _AddUser extends State<AddUser> {
  TextEditingController _pass = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _conf_pass = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final String back = 'assets/svgs/back.svg';
  bool loading = false;
  String msg = "";

  Future<void> SignUpUser(String contact, String mpassword, String fName,
      BuildContext context) async {
    String url = '$BaseUrl/api/users/register';
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
        "contact": contact,
        "password": mpassword,
        "fullName": fName,
        "role": "member"
      }),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 201) {
        //double
        if (parsed["message"] != null) {
          setState(() {
            msg = parsed["message"];
          });
          showText(parsed["message"]);
        }
        setState(() {
          loading = false;
        });
        showText("Added successfully");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LandingPage()));
      } else if (statusCode != 201) {
        showText('payment failed');
        setState(() {
          msg = "Something went wrong";
        });
        setState(() {
          loading = false;
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
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
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
                      'Join',
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
                                  'Fullname',
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
                                  controller: _name,
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      hintText: "Mick Mugume",
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
                                            color: Colors.green, width: 2.0),
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
                                              color: Colors.green, width: 2.0),
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
                                    controller: _conf_pass,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "* Required";
                                      } else if (value != _pass.text) {
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
                                              color: Colors.green, width: 2.0),
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
                                  backgroundColor: Colors.green,
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
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      if (formkey.currentState!.validate()) {
                                        // login
                                        SignUpUser(_contact.text, _pass.text,
                                            _name.text, context);
                                      } else {
                                        showText("Fill the fields correctly");
                                      }
                                    },
                                    child: const Text(
                                      "Sign up",
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
    _pass.dispose();
    _conf_pass.dispose();
    super.dispose();
  }
}
