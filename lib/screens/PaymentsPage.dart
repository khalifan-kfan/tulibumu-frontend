import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tulibumu/utils/widget_functions.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<PaymentsPage> {
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

  List<Map<String, dynamic>> months = [
    {"id": "011", "month": 1, "paid": true, "date": 1646435478181},
    {"id": "012", "month": 2, "paid": true, "date": 1646435478181}
  ];
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
                          onTap: () {},
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
                        images[0]["to"].toString(),
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
                        images[0]["months_paid"].toString(),
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
                        images[0]["months_count"].toString(),
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
                        images[0]["loan_time"].toString(),
                        style: themeData.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(10),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: COLOR_CLICK_GREEN,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13),
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        images[0]["months_paid"] == images[0]["loan_time"]
                            ? "Fully paid"
                            : "Pay for Month" +
                                " " +
                                (images[0]["months_paid"] + 1).toString(),
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
                Expanded(
                  child: Padding(
                    padding: sidePadding,
                    child: ListView.separated(
                      itemBuilder: (BuildContext, index) {
                        return months.length == 0
                            ? Center(child: Text(" no months data"))
                            : MonthItem(
                                month: months[index],
                              );
                      },
                      itemCount: months.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: COLOR_BACK_GROUND,
                      ),
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
              ]),
              Positioned(
                bottom: 20,
                width: size.width,
                height: 150,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                          padding: sidePadding,
                          child: const Divider(
                            thickness: 2,
                            color: Colors.black,
                          )),
                      addVerticalSpace(5),
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
                              images[0]["fine"].toString(),
                              style: themeData.textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      if (images[0]["fine"] > 0)
                        Center(
                          child: GestureDetector(
                            onTap: () {},
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
              ),
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
        padding: const EdgeInsets.only(left: 10, right: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "month" + " " + month["month"].toString(),
            style: themeData.textTheme.bodyText2,
          ),
          Text(
            month["paid"] ? "paid" : "Not paid",
            style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
          Text(
            " ${dd.format(new DateTime.fromMicrosecondsSinceEpoch(month["date"] * 1000))}",
            style: themeData.textTheme.bodyText2,
          ),
        ]),
      ),
    ]);
  }
}
