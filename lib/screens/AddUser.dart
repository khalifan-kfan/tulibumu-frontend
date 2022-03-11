import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import 'package:flutter/services.dart';
import 'package:tulibumu/custom/BorderIcon.dart';
import 'package:tulibumu/main.dart';
//import 'package:tulibumu/screens/SignupPage.dart';
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

  Future<void> SignUpUser(
      String memail, String mpassword, BuildContext context) async {
    showText("Tusanyuse okulaba ;-)");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LandingPage()));
    // try {
    // call api

    //   if (userCredential.user != null) {
    //     // back to landing page
    //     showText("Tusanyuse okulaba ;-)");
    //      Navigator.of(context).push(MaterialPageRoute(
    //        builder: (context) => LandingPage()));
    //     //main();

    //   } else {
    //     // something went wrong
    //     showText("somewthing went wrong");
    //     showText("somewthing went wrong");
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print("no such user");
    //     showText(e.toString());
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //     showText(e.toString());
    //   }
    // } catch (e) {
    //   showText(e.toString());
    //   print(e);
    // }
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
            body: Center(
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
                            children: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    minimumSize: const Size(350, 50),
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    // login
                                    SignUpUser(
                                        _contact.text, _pass.text, context);
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
            ))));
  }

  @override
  void dispose() {
    _pass.dispose();
    _conf_pass.dispose();
    super.dispose();
  }
}