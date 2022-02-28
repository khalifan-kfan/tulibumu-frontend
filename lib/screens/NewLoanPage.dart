import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tulibumu/utils/widget_functions.dart';

class NewLoanPage extends StatefulWidget {
  const NewLoanPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NewLoanPage> {
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
                                    currentColor: null,
                                    fontSize: 12,
                                    xHeight: 6),
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
                  Expanded(
                    child: Padding(
                        padding: sidePadding,
                        child: ListView.separated(
                          itemBuilder: (BuildContext, index) {
                            return LoanItem(
                              record: images[index],
                              user: false,
                            );
                          },
                          itemCount: images.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            color: COLOR_BACK_GROUND,
                          ),
                          scrollDirection: Axis.vertical,
                        )),
                  )
                ]),
              ]),
            ),
          ),
        ));
  }
}

class LoanItem extends StatelessWidget {
  final dynamic record;
  final bool user;

  const LoanItem({Key? key, this.record, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //DateTime record_day = record["date"].toDate();
    final ThemeData themeData = Theme.of(context);

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
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  record["state"] == "complete"
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
                                record["started"].toString(),
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
                          Row(
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
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: COLOR_CLICK_GREEN,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              "Cash loan",
              style: themeData.textTheme.headline5,
            ),
          ),
        ),
      ],
    );
  }
}