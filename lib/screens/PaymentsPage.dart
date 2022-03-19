import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<void> PayLoan(int month, double fine) async {
    String url = '$BaseUrl/api/loans/payment/' + widget.record!["id"];
    setState(() {
      loading = true;
    });

    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{"month": month, "fine": fine}),
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
    // print(AllMonths);
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
                        "Months past",
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
                addVerticalSpace(10),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.record["months_paid"] == widget.record["loan_time"]
                          ? null
                          : showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.amber,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                            'Confirm if you really want to cash this month?' +
                                                " " +
                                                (widget.record["months_paid"] +
                                                        1)
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                height: 1.5)),
                                        addVerticalSpace(14),
                                        if (loading)
                                          Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5,
                                              backgroundColor: Colors.green,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.yellow),
                                            ),
                                          )
                                        else
                                          ElevatedButton(
                                            child: const Text('Confirm'),
                                            onPressed: () => PayLoan(
                                                widget.record["months_paid"] +
                                                    1,
                                                0),
                                          ),
                                        addVerticalSpace(7),
                                        if (!loading)
                                          ElevatedButton(
                                            child: const Text('Cancel'),
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                        widget.record["months_paid"] ==
                                widget.record["loan_time"]
                            ? "Fully paid"
                            : "Pay for Month" +
                                " " +
                                (widget.record["months_paid"] + 1).toString(),
                        style: themeData.textTheme.headline5,
                      ),
                    ),
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
                                : MonthItem(
                                    month: AllMonths[index],
                                  );
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
                              "fine",
                              style: themeData.textTheme.bodyText2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              widget.record["fine"].toString(),
                              style: themeData.textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      if (widget.record["fine"] > 0)
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      color: Colors.amber,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                                'Confirm if you really want to cash this fine?' +
                                                    " " +
                                                    widget.record["fine"]
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.5)),
                                            addVerticalSpace(14),
                                            if (loading)
                                              Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5,
                                                  backgroundColor: Colors.green,
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                          Color>(Colors.yellow),
                                                ),
                                              )
                                            else
                                              ElevatedButton(
                                                child: const Text('Confirm'),
                                                onPressed: () => PayLoan(
                                                    0, widget.record["fine"]),
                                              ),
                                            addVerticalSpace(7),
                                            if (!loading)
                                              ElevatedButton(
                                                child: const Text('Cancel'),
                                                onPressed: () =>
                                                    Navigator.pop(context),
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
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class MonthItem extends StatelessWidget {
  final dynamic month;

  const MonthItem({Key? key, this.month}) : super(key: key);
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
            "month" + " " + month["month"].toString(),
            style: themeData.textTheme.bodyText2,
          ),
          Text(
            month["paid"] == true ? "paid" : "not paid",
            style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
          Text(
            " ${dd.format(new DateTime.fromMicrosecondsSinceEpoch(month["data"]["seconds"] * 1000000))}",
            style: themeData.textTheme.subtitle2,
          ),
        ]),
      ),
    ]);
  }
}
