import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:tulibumu/utils/widget_functions.dart';

import 'LoginScreen.dart';

class EquityPage extends StatefulWidget {
  const EquityPage({Key? key}) : super(key: key);

  @override
  _EquityPage createState() => _EquityPage();
}

class _EquityPage extends State<EquityPage> {
  final String back = 'assets/svgs/back.svg';

  bool loading = false;
  String error = "";
  num Equity = 0;
  Map<String, dynamic>? Myuser;
  TextEditingController _amount = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    getState();
    SetEquity();
    super.initState();
  }

  Future<void> getState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? _token = prefs.getString('token') ?? "";
    if (_token.toString().isNotEmpty) {
      // stay
      Myuser = {
        "id": prefs.getString('id') ?? "",
        "token": _token ?? "",
        "fullName": prefs.getString('fullName') ?? "",
        "role": prefs.getString('role') ?? ""
      };
    } else {
      //login page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  Future<void> SetEquity() async {
    // print('$BaseUrl/api/equity');
    String url = '$BaseUrl/api/equity';

    await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 200) {
        //  print(parsed["total"]);
        setState(() {
          Equity = parsed["total"];
        });
      } else if (statusCode != 200) {
        showText('Equity failed to fetch, trying again');
        //SetEquity();
        setState(() {
          error = "No Internet";
        });
      }
    });
  }

  Future<void> EditEquity(num amount, BuildContext context) async {
    String url = '$BaseUrl/api/equity/update';
    //print(amount);
    setState(() {
      loading = true;
    });
    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{"value": amount}),
    )
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 204) {
        setState(() {
          loading = false;
        });
        showText("Operation Successfull");

        SetEquity();
      } else if (statusCode != 204) {
        setState(() {
          loading = false;
        });
        showText('failed to edit equity.');
        setState(() {
          error = "Check Internet conection";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_BACK_GROUND,
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              addVerticalSpace(padding),
              Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: sidePadding,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: LimitedBox(
                          child: SvgPicture.asset(
                            back,
                            color: Colors.black,
                            width: 40,
                            height: 40,
                            theme: const SvgTheme(
                                currentColor: null, fontSize: 12, xHeight: 6),
                          ),
                          maxHeight: 40,
                          maxWidth: 40,
                        ),
                      ),
                    ),
                    addHorizontalSpace(45),
                    Text(
                      'Edit Equity',
                      textAlign: TextAlign.start,
                      style: themeData.textTheme.headline1,
                    ),
                  ]),
              addVerticalSpace(5),
              Padding(
                padding: sidePadding,
                child: const Divider(
                  height: 25,
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
              addVerticalSpace(20),
              Row(
                children: [
                  Padding(
                    padding: sidePadding,
                    child: Text(
                      "Equity:",
                      style: themeData.textTheme.headline2,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Equity == 0.00 && error.isEmpty
                          ? Text(
                              "loading...",
                              style: themeData.textTheme.bodyText1,
                            )
                          : Equity > 0
                              ? Text(
                                  Equity.toString() + " " + "/=",
                                  style: themeData.textTheme.headline1,
                                )
                              : error.isNotEmpty && Equity == 0
                                  ? Text(
                                      error,
                                      style: themeData.textTheme.bodyText1,
                                    )
                                  : null),
                ],
              ),
              addVerticalSpace(40),
              Padding(
                padding: sidePadding,
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
                              'Amount',
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
                              controller: _amount,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  hintText: "3000000",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  filled: true),
                            ),
                          ],
                        ),
                        addVerticalSpace(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
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
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    minimumSize: const Size(100, 50),
                                    backgroundColor: Colors.blueGrey),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            color: Colors.lightBlue,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Text(
                                                      'Confirm if you really Add to equity.',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.5)),
                                                  addVerticalSpace(14),
                                                  Column(
                                                    children: [
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Confirm'),
                                                        onPressed: () {
                                                          EditEquity(
                                                              num.parse(
                                                                  _amount.text),
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      addVerticalSpace(7),
                                                      ElevatedButton(
                                                        child:
                                                            const Text('Close'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    showText("Fill the fields correctly");
                                  }
                                },
                                child: const Text(
                                  "Add",
                                  style: TextStyle(
                                      fontSize: 20, color: COLOR_WHITE),
                                ),
                              ),
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
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    minimumSize: const Size(100, 50),
                                    backgroundColor: Colors.blueGrey),
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            color: Colors.lightBlue,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Text(
                                                      'Confirm if you really Subtract from equity.',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.5)),
                                                  addVerticalSpace(14),
                                                  Column(
                                                    children: [
                                                      ElevatedButton(
                                                          child: const Text(
                                                              'Confirm'),
                                                          onPressed:
                                                              () => {
                                                                    EditEquity(
                                                                        (num.parse(_amount.text) *
                                                                            -1),
                                                                        context),
                                                                    Navigator.pop(
                                                                        context)
                                                                  }),
                                                      addVerticalSpace(7),
                                                      ElevatedButton(
                                                        child:
                                                            const Text('Close'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    showText("Fill the fields correctly");
                                  }
                                },
                                child: const Text(
                                  "Sub",
                                  style: TextStyle(
                                      fontSize: 20, color: COLOR_WHITE),
                                ),
                              ),
                          ],
                        )
                      ]),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
