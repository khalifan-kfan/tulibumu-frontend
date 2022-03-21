import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tulibumu/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tulibumu/utils/widget_functions.dart';

import 'DetailsPage.dart';
import 'LandingPage.dart';
import 'LoginScreen.dart';

class NewLoanPage extends StatefulWidget {
  const NewLoanPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NewLoanPage> {
  final String back = 'assets/svgs/back.svg';

  bool loading = false;
  String all_msg = "";
  Map<String, dynamic>? Myuser;
  List<dynamic> AllNewLoans = [];
  @override
  void initState() {
    AllLoans();
    getState();
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

  Future<void> AllLoans() async {
    String url = '$BaseUrl/api/loans/new/';

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
            all_msg = parsed["message"];
          });
        } else if (parsed["data"] != null) {
          setState(() {
            AllNewLoans = AllNewLoans + parsed["data"];
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
          all_msg = "Something went wrong";
        });
        setState(() {
          loading = false;
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
                      'New Loan',
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
                  )),
              if (loading)
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    backgroundColor: Colors.blueGrey,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                )
              else if (AllNewLoans.length > 0 && all_msg.isEmpty)
                Expanded(
                  child: Padding(
                      padding: sidePadding,
                      child: ListView.separated(
                        itemBuilder: (BuildContext, index) {
                          return LoanItem(
                              record: AllNewLoans[index],
                              user: false,
                              currentUser: Myuser);
                        },
                        itemCount: AllNewLoans.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: COLOR_BACK_GROUND,
                        ),
                        scrollDirection: Axis.vertical,
                      )),
                )
              else
                Center(
                  child: Text(
                    all_msg,
                    style: themeData.textTheme.headline5,
                  ),
                )
            ]),
          ]),
        ),
      ),
    );
  }
}

class LoanItem extends StatefulWidget {
  final dynamic record;
  final bool user;
  final Map<String, dynamic>? currentUser;

  const LoanItem(
      {Key? key, this.record, required this.user, required this.currentUser})
      : super(key: key);

  @override
  _State__ createState() => _State__();
}

class _State__ extends State<LoanItem> {
  bool isLoading = false;

  Future<void> CashLoan() async {
    String url = '$BaseUrl/api/loans/cashout/' + widget.record["id"];
    setState(() {
      isLoading = true;
    });

    await http
        .put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "confirmer_id": widget.currentUser?["id"],
        "name": widget.currentUser?["fullName"],
      }),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 201) {
        showText("Loan cashed successfullly");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LandingPage()));
        setState(() {
          isLoading = false;
        });
      } else if (statusCode != 201) {
        showText('Failed:' + " " + parsed["message"]);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> CancelLoan() async {
    String url = '$BaseUrl/api/loans/cancel/' + widget.record["id"];
    setState(() {
      isLoading = true;
    });

    await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) {
      final int statusCode = response.statusCode;
      //check status code
      if (statusCode == 204) {
        showText("Loan deleted successfullly");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LandingPage()));
        setState(() {
          isLoading = false;
        });
      } else if (statusCode != 204) {
        showText('Failed to delete loan');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //DateTime record_day = record["date"].toDate();
    final ThemeData themeData = Theme.of(context);
    final dd = DateFormat('dd-MM-yyyy');

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
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: !widget.user
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
                                  widget.record["amount"].toString() + ",",
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
                              widget.record["to"],
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ]
                    : [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 10),
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
                                widget.record["amount"].toString() + "/=",
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
                                children: [
                                  Text(
                                    "Time:",
                                    textAlign: TextAlign.start,
                                    style: themeData.textTheme.bodyText1,
                                  ),
                                  Text(
                                    widget.record["loan_time"].toString(),
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
                                    widget.record["return_total"]
                                        .toInt()
                                        .toString(),
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
                                    (widget.record["monthly_pay"])
                                        .toInt()
                                        .toString(),
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
                                    widget.record["cash_returned"]
                                        .toInt()
                                        .toString(),
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
                                    widget.record["fine"].toInt().toString(),
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
                                  widget.record["state"] == "complete"
                                      ? "done"
                                      : widget.record["state"],
                                  textAlign: TextAlign.end,
                                  style: widget.record["state"]! == "active"
                                      ? const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5)
                                      : widget.record["state"]! == "due"
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
                                widget.record["started"] != "N/A"
                                    ? " ${dd.format(new DateTime.fromMicrosecondsSinceEpoch(widget.record["started"]["seconds"] * 1000000))}"
                                    : widget.record["started"],
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
                                widget.record["months_paid"].toString(),
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
                                widget.record["months_count"].toString(),
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
                                        record: widget.record,
                                        user: widget.currentUser!["role"],
                                      )));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
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
            ],
          ),
        ),
        addVerticalSpace(10),
        GestureDetector(
          onTap: () {
            // CashLoan();
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Colors.lightBlue,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                              'Confirm if you really want to cash this loan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5)),
                          addVerticalSpace(14),
                          if (isLoading)
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
                              children: [
                                ElevatedButton(
                                  child: const Text('Confirm'),
                                  onPressed: () => CashLoan(),
                                ),
                                addVerticalSpace(7),
                                ElevatedButton(
                                  child: const Text('Cancel Loan'),
                                  onPressed: () => CancelLoan(),
                                ),
                                addVerticalSpace(7),
                                ElevatedButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Container(
            decoration: BoxDecoration(
              color: COLOR_CLICK_GREEN,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              "Cash or cancel loan",
              style: themeData.textTheme.headline5,
            ),
          ),
        ),
      ],
    );
  }
}
