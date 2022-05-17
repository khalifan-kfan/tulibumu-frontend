import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tulibumu/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tulibumu/utils/widget_functions.dart';

import 'LandingPage.dart';

class PaymentsPage extends StatefulWidget {
  final dynamic record;
  final dynamic user;

  const PaymentsPage({Key? key, required this.record, required this.user})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<PaymentsPage> {
  final String back = 'assets/svgs/back.svg';
  bool loading = false;
  String msg = "";
  String msg_pay = "";
  List<dynamic> AllMonths = [];
  TextEditingController fine = TextEditingController();

  Future<void> IntialMonth() async {
    String url = '$BaseUrl/api/loans/months/' + widget.record!["id"];
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
            msg = parsed["message"];
          });
        } else if (parsed["data"] != null) {
          // print(parsed["data"]);
          setState(() {
            AllMonths = parsed["data"];
          });
        }
        setState(() {
          loading = false;
        });
      } else if (statusCode != 200) {
        showText(parsed["message"]);
        //SetEquity();
        setState(() {
          msg = parsed["message"];
        });
        setState(() {
          loading = false;
        });
      }
    });
    // print(AllMonths);
  }

  @override
  void initState() {
    IntialMonth();
    super.initState();
  }

  //extra months loan
  Future<void> payLoanFine(num fine) async {
    String url = '$BaseUrl/api/loans/month/payment/' + widget.record!["id"];

    setState(() {
      loading = true;
    });

    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, num>{"month": 0, "amount": 0, "fine": fine}),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 200) {
        //double
        if (parsed["message"] != null) {
          setState(() {
            msg_pay = parsed["message"];
          });
          showText(parsed["message"]);
        }
        setState(() {
          loading = false;
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LandingPage()));
      } else if (statusCode != 200) {
        // print(parsed["message"]);
        showText('payment failed');
        //SetEquity();
        setState(() {
          msg_pay = "Something went wrong";
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
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
                        'Payments',
                        textAlign: TextAlign.start,
                        style: themeData.textTheme.headline1,
                      ),
                    ]),
                addVerticalSpace(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Loan For:",
                        style: themeData.textTheme.headline2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.record["to"].toString(),
                        style: themeData.textTheme.headline4,
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(5),
                Padding(
                    padding: sidePadding,
                    child: const Divider(
                      height: 25,
                      thickness: 2,
                      color: Colors.black,
                    )),
                addVerticalSpace(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Months paid",
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.record["months_paid"].toString(),
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Current month",
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.record["months_count"].toString(),
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Loan time",
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.record["loan_time"].toString(),
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
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
                      backgroundColor: Colors.green,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ),
                  )
                else if (AllMonths.length > 0 && msg.isEmpty)
                  Container(
                    height: (size.height * 0.01) * 37,
                    child: Padding(
                        padding: sidePadding,
                        child: ListView.separated(
                          itemBuilder: (BuildContext, index) {
                            return AllMonths.length == 0
                                ? Center(child: Text(" no months data"))
                                : (AllMonths[index]["month"] <=
                                        widget.record["months_count"])
                                    ? MonthItem(
                                        month: AllMonths[index],
                                        record: widget.record)
                                    : addVerticalSpace(0.1);
                          },
                          itemCount: AllMonths.length,
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
                      msg,
                      style: themeData.textTheme.headline5,
                    ),
                  ),
                addVerticalSpace(2),
                Center(
                  child: Column(
                    children: [
                      Padding(
                          padding: sidePadding,
                          child: const Divider(
                            thickness: 2,
                            color: Colors.black,
                          )),
                      addVerticalSpace(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              "Total fine",
                              style: themeData.textTheme.bodyText2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              widget.record["fine"].toInt().toString(),
                              style: themeData.textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      if (widget.record["fine"] > 1 &&
                          widget.record["type"] != "Mayungano")
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                  controller: fine,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "* Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]+')),
                                  ],
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(13, 13, 13, 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blueGrey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      hintText: "50000",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      filled: true)),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  fine.text == ""
                                      ? null
                                      : showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              color: Colors.lightBlue,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                        'Confirm if you really want to cash this fine?',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.5)),
                                                    addVerticalSpace(14),
                                                    if (loading)
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 5,
                                                          backgroundColor:
                                                              Colors.green,
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors
                                                                      .yellow),
                                                        ),
                                                      )
                                                    else
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Confirm'),
                                                        onPressed: () => fine
                                                                    .text ==
                                                                ""
                                                            ? null
                                                            : payLoanFine(
                                                                int.parse(
                                                                    fine.text)),
                                                      ),
                                                    addVerticalSpace(7),
                                                    if (!loading)
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      )
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 13),
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "pay fine",
                                    style: themeData.textTheme.headline5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if ((widget.record["type"] == "Mayungano" &&
                          widget.record["months_paid"] ==
                              widget.record["loan_time"] &&
                          widget.record["fine"] > 1))
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                  controller: fine,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "* Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]+')),
                                  ],
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(13, 13, 13, 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blueGrey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      hintText: "50000",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      filled: true)),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  fine.text == ""
                                      ? null
                                      : showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              color: Colors.lightBlue,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                        'Confirm if you really want to cash this fine?',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.5)),
                                                    addVerticalSpace(14),
                                                    if (loading)
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 5,
                                                          backgroundColor:
                                                              Colors.green,
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors
                                                                      .yellow),
                                                        ),
                                                      )
                                                    else
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Confirm'),
                                                        onPressed: () => fine
                                                                    .text ==
                                                                ""
                                                            ? null
                                                            : payLoanFine(
                                                                int.parse(
                                                                    fine.text)),
                                                      ),
                                                    addVerticalSpace(7),
                                                    if (!loading)
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      )
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 13),
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "pay fine",
                                    style: themeData.textTheme.headline5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class MonthItem extends StatefulWidget {
  final dynamic month;
  final dynamic record;

  const MonthItem({Key? key, this.month, this.record}) : super(key: key);

  @override
  _State_ createState() => _State_();
}

class _State_ extends State<MonthItem> {
  TextEditingController _fine = TextEditingController();
  TextEditingController _amount = TextEditingController();

  bool loading = false;

  Future<void> loanPayments(num month, num amount, num fine) async {
    String url = '$BaseUrl/api/loans/month/payment/' + widget.record!["id"];
    setState(() {
      loading = true;
    });
    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <String, num>{"month": month, "amount": amount, "fine": fine}),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 200) {
        //double
        if (parsed["message"] != null) {
          showText(parsed["message"]);
        }
        setState(() {
          loading = false;
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LandingPage()));
      } else if (statusCode != 200) {
        showText('payment failed');
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //DateTime record_day = record["date"].toDate();
    final ThemeData themeData = Theme.of(context);

    final dd = new DateFormat('dd-MM-yyyy');
    return Column(children: [
      Container(
        height: 20,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "MONTH" + " " + widget.month["month"].toString(),
            style: themeData.textTheme.bodyText2,
          ),
          Text(
            widget.month["paid"] == true ? "paid" : "not paid",
            style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
          if (widget.month["data"] != 0)
            Text(
              " ${dd.format(new DateTime.fromMicrosecondsSinceEpoch(widget.month["data"]["seconds"] * 1000000))}",
              style: themeData.textTheme.subtitle2,
            ),
        ]),
      ),
      addVerticalSpace(2),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Paid: " +
                widget.month["amount_paid"].toString() +
                " of " +
                widget.record["monthly_pay"].toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.0,
              color: Colors.black,
            ),
          ),
          addVerticalSpace(2),
          if (widget.month["amount_paid"] < widget.record["monthly_pay"])
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        controller: _amount,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                        ],
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(13, 13, 13, 0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: "70000",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            filled: true)),
                  ],
                ),
              ),
              addHorizontalSpace(4),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loading)
                      Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          backgroundColor: Colors.green,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.yellow),
                        ),
                      )
                    else
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text('Pay'),
                              onPressed: () => {
                                _amount.text == ""
                                    ? null
                                    : showModalBottomSheet<void>(
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
                                                  Text(
                                                      'Confirm if you really want to cash this month?' +
                                                          " " +
                                                          (widget.record[
                                                                      "months_paid"] +
                                                                  1)
                                                              .toString(),
                                                      style:
                                                          TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 1.5)),
                                                  addVerticalSpace(14),
                                                  if (loading)
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 5,
                                                        backgroundColor:
                                                            Colors.green,
                                                        valueColor:
                                                            new AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.yellow),
                                                      ),
                                                    )
                                                  else
                                                    ElevatedButton(
                                                        child: const Text(
                                                            'Confirm'),
                                                        onPressed: () => {
                                                              loanPayments(
                                                                  widget.month[
                                                                      "month"],
                                                                  num.parse(
                                                                      _amount
                                                                          .text),
                                                                  0)
                                                            }),
                                                  addVerticalSpace(7),
                                                  if (!loading)
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    )
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                              },
                            ),
                          ]),
                  ],
                ),
              ),
            ])
        ],
      ),
      if (widget.record["type"] == "Mayungano")
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Month fine: " + widget.month["fine"].toInt().toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.0,
                color: Colors.black,
              ),
            ),
            addVerticalSpace(2),
            if (widget.month["fine"] > 0)
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                          controller: _fine,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "* Required";
                            } else {
                              return null;
                            }
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]+')),
                          ],
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(13, 13, 13, 0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              hintText: "50000",
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              filled: true)),
                    ],
                  ),
                ),
                addHorizontalSpace(4),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child: const Text('pay fine'),
                                onPressed: () => {
                                  _fine.text == ""
                                      ? null
                                      : showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              color: Colors.lightBlue,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                        'Confirm if you really want to pay fine for month?',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.5)),
                                                    addVerticalSpace(14),
                                                    if (loading)
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 5,
                                                          backgroundColor:
                                                              Colors.green,
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors
                                                                      .yellow),
                                                        ),
                                                      )
                                                    else
                                                      ElevatedButton(
                                                          child: const Text(
                                                              'Confirm'),
                                                          onPressed:
                                                              () => {
                                                                    loanPayments(
                                                                        widget.month[
                                                                            "month"],
                                                                        0,
                                                                        num.parse(
                                                                            _fine.text))
                                                                  }),
                                                    addVerticalSpace(7),
                                                    if (!loading)
                                                      ElevatedButton(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                      )
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                },
                              ),
                            ]),
                    ],
                  ),
                ),
              ])
          ],
        ),
      Divider(
        height: 25,
        thickness: 2,
        color: Colors.black,
      ),
    ]);
  }
}
