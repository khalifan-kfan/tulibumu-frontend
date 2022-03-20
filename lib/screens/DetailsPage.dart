import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tulibumu/screens/PaymentsPage.dart';
import 'package:tulibumu/utils/constants.dart';

import 'package:tulibumu/utils/widget_functions.dart';

class DetailsPage extends StatefulWidget {
  final dynamic record;
  final String user;
  const DetailsPage({Key? key, required this.record, required this.user})
      : super(key: key);

  @override
  Details_ createState() {
    return Details_();
  }
}

class Details_ extends State<DetailsPage> {
  final String back = 'assets/svgs/back.svg';
  final dd = new DateFormat('dd-MM-yyyy');

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
          child: Stack(
            children: [
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
                        'Loan',
                        textAlign: TextAlign.start,
                        style: themeData.textTheme.headline1,
                      ),
                    ]),
                addVerticalSpace(5),
                Row(
                  children: [
                    Padding(
                      padding: sidePadding,
                      child: Text(
                        "Amount:",
                        style: themeData.textTheme.headline2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.record["amount"].toString(),
                        style: themeData.textTheme.headline1,
                      ),
                    ),
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
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(children: [
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.headline4,
                          ),
                          Text(widget.record["to"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.headline4),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["loan_time"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["state"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "started:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(
                              widget.record["started"] != "N/A"
                                  ? " ${dd.format(new DateTime.fromMicrosecondsSinceEpoch(widget.record["started"]["seconds"] * 1000000))}"
                                  : widget.record["started"],
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Months paid:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["months_paid"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Months past:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["months_count"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Interest:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["intrest"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Monthly return:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["monthly_pay"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "paid:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["cash_returned"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Fine:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["fine"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total return:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["return_total"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Penalty rate:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["penalty_rate"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Penalty rate on:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(widget.record["penalty_rate_on"].toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Confirmed by:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Text(
                              widget.record["confirmer"] == ""
                                  ? "Not yet"
                                  : widget.record["confirmer"]["name"]
                                      .toString(),
                              textAlign: TextAlign.end,
                              style: themeData.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    addVerticalSpace(2),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Officers:",
                            textAlign: TextAlign.start,
                            style: themeData.textTheme.bodyText1,
                          ),
                          Column(
                            children: [
                              Text(widget.record["approver"][0].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1),
                              Text(widget.record["approver"][1].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1),
                              Text(widget.record["approver"][2].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1),
                            ],
                          ),
                        ],
                      ),
                    ),
                    addVerticalSpace(6),
                  ]),
                ),
                addVerticalSpace(5),
                if ((widget.user == "treasurer" || widget.user == "admin") &&
                    widget.record["state"] != "new")
                  Center(
                    child: Column(
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              minimumSize: const Size(300, 40),
                              backgroundColor: Colors.blueGrey),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PaymentsPage(
                                      record: widget.record,
                                      user: widget.user,
                                    )));
                          },
                          child: const Text(
                            "Register Payments",
                            style: TextStyle(fontSize: 14, color: COLOR_WHITE),
                          ),
                        ),
                      ],
                    ),
                  )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
