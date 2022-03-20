import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tulibumu/custom/BorderIcon.dart';
import 'package:tulibumu/screens/DetailsPage.dart';
import 'package:tulibumu/screens/PaymentsPage.dart';
import 'package:http/http.dart' as http;

import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';

import 'MyDrawer.dart';
import 'LoginScreen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  LandingPage_ createState() {
    return LandingPage_();
  }
}

class LandingPage_ extends State<LandingPage> {
  late int chosen = 1;

  num Equity = 0;
  String error = "";
  Map<String, dynamic>? Myuser;

  List<dynamic> AllLoans = [];
  List<dynamic> LiveLoans = [];
  List<dynamic> AllUserLoans = [];
  String loans_msg = "";
  String live_loans_msg = "";
  String all_loans_msg = "";

  bool loading = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Future<void> IntialLoans() async {
    String url = '$BaseUrl/api/loans/';
    setState(() {
      loading = true;
    });

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
        //double
        if (parsed["message"] != null) {
          setState(() {
            loans_msg = parsed["message"];
          });
        } else if (parsed["data"] != null) {
          setState(() {
            AllLoans = parsed["data"];
          });
        }
        setState(() {
          loading = false;
        });
      } else if (statusCode != 200) {
        showText(
            'Loans failed to fetch, trying again with internet connection');
        //SetEquity();
        setState(() {
          loans_msg = "Something went wrong";
        });
        setState(() {
          loading = false;
        });
      }
    });
    //  print(AllLoans);
  }

  Future<void> UserLive() async {
    String url = '$BaseUrl/api/users/loans/all/' + Myuser!["id"];
    String MyId = Myuser!["id"] ?? "";

    if (MyId.isNotEmpty) {
      setState(() {
        loading = true;
      });
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
          //double
          if (parsed["message"] != null) {
            setState(() {
              live_loans_msg = parsed["message"];
            });
          } else if (parsed["data"] != null) {
            setState(() {
              LiveLoans = parsed["data"];
            });
          }
          setState(() {
            loading = false;
          });
        } else if (statusCode == 403) {
          showText('No active loans for you');
          //SetEquity();
          setState(() {
            live_loans_msg = "No active loans for you";
          });
          setState(() {
            loading = false;
          });
        } else {
          setState(() {
            live_loans_msg =
                "Something went wrong, try checking you internet connection";
          });
        }
      });
    } else {
      setState(() {
        live_loans_msg = "Login out and logback in";
      });
    }
    // print(LiveLoans);
  }

  Future<void> AUserLoans() async {
    String url = '$BaseUrl/api/users/loans/' + Myuser!["id"];
    String MyId = Myuser!["id"] ?? "";

    if (MyId.isNotEmpty) {
      setState(() {
        loading = true;
      });
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
          //double
          if (parsed["message"] != null) {
            setState(() {
              all_loans_msg = parsed["message"];
            });
          } else if (parsed["data"] != null) {
            setState(() {
              AllUserLoans = parsed["data"];
            });
          }
          setState(() {
            loading = false;
          });
        } else if (statusCode != 200) {
          showText(
              'Loans failed to fetch, trying again with internet connection');
          //SetEquity();
          setState(() {
            all_loans_msg = "Something went wrong";
          });
          setState(() {
            loading = false;
          });
        }
      });
    } else {
      setState(() {
        all_loans_msg = "Login out and logback in";
      });
    }
    //print(AllUserLoans);
  }

  @override
  void initState() {
    chosen = 1;
    getState();
    SetEquity();
    IntialLoans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    double padding = 25;

    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: COLOR_BACK_GROUND,
          drawer: MyDrawer(
            user: Myuser ?? {},
          ),
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                Column(
                  // widgets to start from line start
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addVerticalSpace(padding),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: sidePadding,
                            child: GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              child: const BorderIcon(
                                child: Icon(
                                  Icons.menu,
                                  color: COLOR_BLACK,
                                ),
                                padding: EdgeInsets.all(2.0),
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          addHorizontalSpace(45),
                          Text(
                            'Tulibumu',
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.headline1,
                          ),
                        ]),
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
                                            style:
                                                themeData.textTheme.bodyText1,
                                          )
                                        : null),
                      ],
                    ),
                    Padding(
                        padding: sidePadding,
                        child: const Divider(
                          height: 25,
                          thickness: 1,
                          color: Colors.black,
                        )),
                    SingleChildScrollView(
                      // horizontal scroller
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Row(
                          // to make this list clickalbe
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  chosen = 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: chosen == 1
                                      ? COLOR_CLICK_GREEN
                                      : COLOR_UNCLICKER_GREEN,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 13),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "All loans",
                                  style: themeData.textTheme.headline5,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  chosen = 2;
                                });
                                UserLive();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: chosen == 2
                                      ? COLOR_CLICK_GREEN
                                      : COLOR_UNCLICKER_GREEN,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 13),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "My live Loans",
                                  style: themeData.textTheme.headline5,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  chosen = 3;
                                });
                                AUserLoans();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: chosen == 3
                                      ? COLOR_CLICK_GREEN
                                      : COLOR_UNCLICKER_GREEN,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 13),
                                margin: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "All my Loans",
                                  style: themeData.textTheme.headline5,
                                ),
                              ),
                            ),
                          ]
                          // .map((filter) => ChoiceOption(text: filter,position: chosen,))
                          //.toList()
                          ),
                    ),
                    addVerticalSpace(5),
                    Padding(
                        padding: sidePadding,
                        child: const Divider(
                          height: 25,
                          thickness: 1,
                          color: Colors.black,
                        )),
                    if (chosen == 1)
                      if (loading)
                        Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            backgroundColor: Colors.green,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.yellow),
                          ),
                        )
                      else if (AllLoans.length > 0 && loans_msg.isEmpty)
                        Expanded(
                          child: Padding(
                              padding: sidePadding,
                              child: ListView.separated(
                                itemBuilder: (BuildContext, index) {
                                  return LoanItem(
                                      record: AllLoans[index],
                                      user: false,
                                      choice: chosen,
                                      role: Myuser!["role"],
                                      CurrentUser: Myuser);
                                },
                                itemCount: AllLoans.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  color: COLOR_BACK_GROUND,
                                ),
                                scrollDirection: Axis.vertical,
                              )),
                        )
                      else
                        Center(
                          child: Text(
                            loans_msg,
                            style: themeData.textTheme.headline5,
                          ),
                        )
                    else if (chosen == 2)
                      if (loading)
                        Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            backgroundColor: Colors.green,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.yellow),
                          ),
                        )
                      else if (LiveLoans.length > 0 && live_loans_msg.isEmpty)
                        Expanded(
                          child: Padding(
                              padding: sidePadding,
                              child: ListView.separated(
                                itemBuilder: (BuildContext, index) {
                                  return LoanItem(
                                      record: LiveLoans[index],
                                      user: true,
                                      choice: chosen,
                                      role: Myuser!["role"],
                                      CurrentUser: Myuser);
                                },
                                itemCount: LiveLoans.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  color: COLOR_BACK_GROUND,
                                ),
                                scrollDirection: Axis.vertical,
                              )),
                        )
                      else
                        Center(
                          child: Text(
                            live_loans_msg,
                            style: themeData.textTheme.headline5,
                          ),
                        )
                    else if (chosen == 3)
                      if (loading)
                        Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            backgroundColor: Colors.green,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.yellow),
                          ),
                        )
                      else if (AllUserLoans.length > 0 && all_loans_msg.isEmpty)
                        Expanded(
                          child: Padding(
                              padding: sidePadding,
                              child: ListView.separated(
                                itemBuilder: (BuildContext, index) {
                                  return LoanItem(
                                      record: AllUserLoans[index],
                                      user: true,
                                      choice: chosen,
                                      role: Myuser!["role"],
                                      CurrentUser: Myuser);
                                },
                                itemCount: AllUserLoans.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                  color: COLOR_BACK_GROUND,
                                ),
                              )),
                        )
                      else
                        Center(
                          child: Text(
                            all_loans_msg,
                            style: themeData.textTheme.headline5,
                          ),
                        )
                    else
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Logout and log back in",
                            style: themeData.textTheme.headline5,
                          ),
                        ),
                      )
                  ],
                ),
                /*  Positioned(
                  bottom: 20,
                  width: size.width,
                  child: Center(
                    child: OptionButton(
                      text: "HI",
                      icon: Icons.map_rounded,
                      width: size.width * 0.35,
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoanItem extends StatelessWidget {
  final dynamic record;
  final bool user;
  final int choice;
  final String role;
  final dynamic CurrentUser;

  const LoanItem(
      {Key? key,
      this.record,
      required this.user,
      required this.choice,
      required this.role,
      required this.CurrentUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    //DateTime record_day = record["date"].toDate();
    final ThemeData themeData = Theme.of(context);
    // print(role);
    final dd = new DateFormat('dd-MM-yyyy');
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: !user
                      ? [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Amount:",
                                    textAlign: TextAlign.start,
                                    style: themeData.textTheme.bodyText1,
                                  ),
                                  addHorizontalSpace(1),
                                  Text(
                                    record["amount"].toString() + ",",
                                    textAlign: TextAlign.end,
                                    style: themeData.textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 2, right: 5, top: 10),
                              child: Text(
                                record["to"],
                                textAlign: TextAlign.end,
                                style: themeData.textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ]
                      : [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Amount:",
                                  textAlign: TextAlign.start,
                                  style: themeData.textTheme.bodyText1,
                                ),
                                addHorizontalSpace(1),
                                Text(
                                  record["amount"].toString() + "/=",
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ],
                ),
                const Divider(
                  //   height: 25,
                  thickness: 1,
                  color: Colors.green,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Time:",
                                      textAlign: TextAlign.start,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                    Text(
                                      record["loan_time"].toString(),
                                      textAlign: TextAlign.end,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                addVerticalSpace(3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Return:",
                                      textAlign: TextAlign.start,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                    Text(
                                      record["return_total"].toString(),
                                      textAlign: TextAlign.end,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                addVerticalSpace(3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Monthly Return:",
                                      textAlign: TextAlign.start,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                    Text(
                                      record["monthly_pay"].toString(),
                                      textAlign: TextAlign.end,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                addVerticalSpace(3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Returned so far:",
                                      textAlign: TextAlign.start,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                    Text(
                                      record["cash_returned"].toString(),
                                      textAlign: TextAlign.end,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                addVerticalSpace(3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Fine so far:",
                                      textAlign: TextAlign.start,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                    Text(
                                      record["fine"].toString(),
                                      textAlign: TextAlign.end,
                                      style: themeData.textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: .6,
                        color: Colors.green,
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status:",
                                  textAlign: TextAlign.start,
                                  style: themeData.textTheme.bodyText1,
                                ),
                                Text(
                                    record["state"] == "completed"
                                        ? "done"
                                        : record["state"],
                                    textAlign: TextAlign.end,
                                    style: record["state"]! == "active"
                                        ? const TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5)
                                        : record["state"]! == "due"
                                            ? const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5)
                                            : themeData.textTheme.bodyText1),
                              ],
                            ),
                            addVerticalSpace(3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Started:",
                                  textAlign: TextAlign.start,
                                  style: themeData.textTheme.bodyText1,
                                ),
                                Text(
                                  record["started"] != "N/A"
                                      ? " ${dd.format(new DateTime.fromMicrosecondsSinceEpoch(record["started"]["seconds"] * 1000000))}"
                                      : record["started"],
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.subtitle2,
                                ),
                              ],
                            ),
                            addVerticalSpace(3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Months paid:",
                                  textAlign: TextAlign.start,
                                  style: themeData.textTheme.bodyText1,
                                ),
                                Text(
                                  record["months_paid"].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1,
                                ),
                              ],
                            ),
                            addVerticalSpace(3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Months past:",
                                  textAlign: TextAlign.start,
                                  style: themeData.textTheme.bodyText1,
                                ),
                                Text(
                                  record["months_count"].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1,
                                ),
                              ],
                            ),
                            addVerticalSpace(3),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                          record: record,
                                          user: role,
                                        )));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "more",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5),
                                  ),
                                  Text(
                                    "....",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        addVerticalSpace(5),
        if ((choice == 2 || choice == 1) &&
            (role == "treasurer" || role == "admin"))
          Column(
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    minimumSize: const Size(300, 40),
                    backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaymentsPage(
                            record: record,
                            user: CurrentUser,
                          )));
                },
                child: const Text(
                  "Register Payments",
                  style: TextStyle(fontSize: 14, color: COLOR_WHITE),
                ),
              ),
            ],
          )
      ],
    );
  }
}
