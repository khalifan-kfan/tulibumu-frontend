import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tulibumu/screens/PaymentsPage.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tulibumu/utils/widget_functions.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Details_ createState() {
    return Details_();
  }
}

class Details_ extends State<DetailsPage> {
  final String back = 'assets/svgs/back.svg';

  List<Map<String, dynamic>> images = [
    {
      "id": "011",
      "amount": 70005544,
      "to": "Muwonge khalifsn",
      "to_id": "003403",
      "approver": ["hfdjf", "hfgi", "dsiuvh"],
      "state": "active",
      "loan_time": 10,
      "started": 0,
      "intrest": 0.025,
      "monthly_pay": 94090303,
      "cashed": true,
      "penalty_rate": 0.035,
      "penalty_rate_on": "monthly_pay",
      "fine": 0,
      "confirmer": "julz",
      "cash_returned": 44230234,
      "months_count": 0,
      "months_paid": 0,
      "return_total": 4738473472
    },
  ];
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
                        images[0]["amount"].toString(),
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
                          Text(images[0]["to"].toString(),
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
                          Text(images[0]["loan_time"].toString(),
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
                          Text(images[0]["state"].toString(),
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
                          Text(images[0]["started"].toString(),
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
                          Text(images[0]["months_paid"].toString(),
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
                          Text(images[0]["months_count"].toString(),
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
                          Text(images[0]["intrest"].toString(),
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
                          Text(images[0]["monthly_pay"].toString(),
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
                          Text(images[0]["cash_returned"].toString(),
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
                          Text(images[0]["fine"].toString(),
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
                          Text(images[0]["return_total"].toString(),
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
                          Text(images[0]["penalty_rate"].toString(),
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
                          Text(images[0]["penalty_rate_on"].toString(),
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
                          Text(images[0]["confirmer"].toString(),
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
                              Text(images[0]["approver"][0].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1),
                              Text(images[0]["approver"][1].toString(),
                                  textAlign: TextAlign.end,
                                  style: themeData.textTheme.bodyText1),
                              Text(images[0]["approver"][2].toString(),
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
                Center(
                  child: Column(
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            minimumSize: const Size(300, 40),
                            backgroundColor: Colors.green),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PaymentsPage()));
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
