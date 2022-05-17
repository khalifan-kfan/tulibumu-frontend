import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tulibumu/screens/LandingPage.dart';

import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';
import 'package:http/http.dart' as http;

class AddLoan extends StatefulWidget {
  final List<dynamic> users;

  const AddLoan({Key? key, required this.users}) : super(key: key);

  @override
  _addloan_ createState() => _addloan_();
}

class _addloan_ extends State<AddLoan> {
  TextEditingController _amount = TextEditingController();
  TextEditingController _months = TextEditingController();
  TextEditingController _pen = TextEditingController();
  TextEditingController _rate = TextEditingController();

  List<String> _pen_on = ["Monthly pay", "Amount"];
  String selectedName = "";
  List<String> MyNames = [];
  String selectedPenOn = "";
  bool loading = false;
  late int chosenLoan = 1;
  late int chosenMoney = 5;

  var change = 0;
  @override
  void initState() {
    selectedPenOn = _pen_on[1];
    MyNames = BringNames(widget.users);
    selectedName = MyNames[0];
    super.initState();
  }

  double ReturnCoputation() {
    var interest =
        double.parse(_amount.text) * (double.parse(_rate.text) / 100);
    var total =
        (interest * double.parse(_months.text)) + double.parse(_amount.text);
    return (total / double.parse(_months.text));
  }

  List<String> BringNames(List<dynamic> user) {
    List<String> MyNames = [];
    for (int i = 0; i < user.length; i += 1) {
      MyNames.add(user[i]["fullName"]);
    }
    //print(MyNames);
    return MyNames;
  }

  Future<void> _addloan(String amount, String months, String pen, String rate,
      String type, BuildContext context) async {
    setState(() {
      loading = true;
    });
    String url = '$BaseUrl/api/loans/add';
    String to_id = '';
    List<String> officers = [];
    for (int i = 0; i < widget.users.length; i += 1) {
      if (widget.users[i]["fullName"] == selectedName) {
        to_id = widget.users[i]["id"];
      }
      if (widget.users[i]["role"] == "officer") {
        officers.add(widget.users[i]["fullName"]);
      }
    }

    await http
        .post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "amount": chosenLoan == 3
            ? int.parse(amount)
            : chosenLoan == 2
                ? 30000000
                : chosenLoan == 1
                    ? (chosenMoney * 1000000)
                    : 0,
        "to": selectedName,
        "to_id": to_id,
        "approver": officers,
        "loan_time": chosenLoan == 3
            ? int.parse(months)
            : chosenLoan == 2
                ? 3
                : chosenLoan == 1
                    ? 10
                    : 0,
        "intrest": chosenLoan == 3
            ? (double.parse(rate) / 100)
            : chosenLoan == 2
                ? 0.025
                : chosenLoan == 1
                    ? 0.025
                    : 0,
        "penalty_rate": chosenLoan == 3
            ? (double.parse(pen) / 100)
            : chosenLoan == 2
                ? 0.035
                : chosenLoan == 1
                    ? 0.035
                    : 0,
        "penalty_rate_on": chosenLoan == 3
            ? selectedPenOn
            : chosenLoan == 2
                ? "Monthly pay"
                : chosenLoan == 1
                    ? "Monthly pay"
                    : "",
        "type": type
      }),
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      //check status code
      final parsed = json.decode(res) as Map<String, dynamic>;
      if (statusCode == 201) {
        //double
        if (parsed["message"] != null) {
          // print(parsed["data"]);
          setState(() {
            loading = false;
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LandingPage()));
        } else if (statusCode != 201) {
          setState(() {
            loading = false;
          });
          showText("can't add loan, try agin letter ");
        }
      }
    });
  }

  @override
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final String back = 'assets/svgs/back.svg';

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
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: LimitedBox(
                child: SvgPicture.asset(
                  back,
                  color: Colors.black,
                  width: 40,
                  height: 40,
                  theme: SvgTheme(currentColor: null, fontSize: 12, xHeight: 6),
                ),
                maxHeight: 40,
                maxWidth: 40,
              ),
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Text(
                "Add Loan",
                style: TextStyle(
                    fontSize: 25.0,
                    letterSpacing: 1.0,
                    color: Colors.black,
                    fontFamily: "Comfortaa"),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          addVerticalSpace(5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name for the loan ownwer.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                              addVerticalSpace(2),
                              DropdownButton<String>(
                                value: selectedName == "" ? "" : selectedName,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blueGrey,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedName = newValue!;
                                  });
                                },
                                items: MyNames.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          addVerticalSpace(5),
                          const Text(
                            'Loan type',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          addVerticalSpace(2),
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
                                        chosenLoan = 1;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: chosenLoan == 1
                                            ? COLOR_CLICK_GREEN
                                            : COLOR_UNCLICKER_GREEN,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 13),
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Mayongano",
                                        style: themeData.textTheme.headline5,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        chosenLoan = 2;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: chosenLoan == 2
                                            ? COLOR_CLICK_GREEN
                                            : COLOR_UNCLICKER_GREEN,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 13),
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Bulky",
                                        style: themeData.textTheme.headline5,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        chosenLoan = 3;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: chosenLoan == 3
                                            ? COLOR_CLICK_GREEN
                                            : COLOR_UNCLICKER_GREEN,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 13),
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Custom",
                                        style: themeData.textTheme.headline5,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          if (chosenLoan == 1)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mayungano loan Money in (Millions)',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            chosenMoney = 5;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: chosenMoney == 5
                                                ? COLOR_CLICK_GREEN
                                                : COLOR_UNCLICKER_GREEN,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 13),
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "5",
                                            style:
                                                themeData.textTheme.headline5,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            chosenMoney = 10;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: chosenMoney == 10
                                                ? COLOR_CLICK_GREEN
                                                : COLOR_UNCLICKER_GREEN,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 13),
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "10",
                                            style:
                                                themeData.textTheme.headline5,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            chosenMoney = 15;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: chosenMoney == 15
                                                ? COLOR_CLICK_GREEN
                                                : COLOR_UNCLICKER_GREEN,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 13),
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "15",
                                            style:
                                                themeData.textTheme.headline5,
                                          ),
                                        ),
                                      ),
                                    ]),
                                const Text(
                                  'This loan is issued for',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                Text(
                                  "Amount: " +
                                      (chosenMoney.toInt() * 1000000)
                                          .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Time: 10 months",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Interest: 2.5%",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                Text(
                                  "Monthly Pay:" +
                                      ((((0.025 *
                                                          (chosenMoney.toInt() *
                                                              1000000)) *
                                                      10) +
                                                  (chosenMoney.toInt() *
                                                      1000000)) /
                                              10)
                                          .toInt()
                                          .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Penalty Interest per missed month: 2.5% on monthly pay",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Penalty Interest for extra months: 3.5% on total unpaid money",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(10),
                                if (loading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      backgroundColor: Colors.blueGrey,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.yellow),
                                    ),
                                  )
                                else
                                  Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          minimumSize: const Size(350, 50),
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        _addloan("", "", "", "", "Mayungano",
                                            context);
                                      },
                                      child: const Text(
                                        "Add Loan",
                                        style: TextStyle(
                                            fontSize: 20, color: COLOR_WHITE),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          if (chosenLoan == 2)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'This loan is issued for',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Amount: 30,000,000",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Time: 3 months",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Interest: 2.5%",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                Text(
                                  "Monthly Pay:" +
                                      ((((0.025 * 30000000) * 3) + 30000000) /
                                              3)
                                          .toInt()
                                          .toString(),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Penalty Interest for extra months: 3.5% on monthly pay",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                addVerticalSpace(10),
                                if (loading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      backgroundColor: Colors.blueGrey,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.yellow),
                                    ),
                                  )
                                else
                                  Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          minimumSize: const Size(350, 50),
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        // send loan
                                        _addloan(
                                            "", "", "", "", "Bulky", context);
                                      },
                                      child: const Text(
                                        "Add Loan",
                                        style: TextStyle(
                                            fontSize: 20, color: COLOR_WHITE),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          if (chosenLoan == 3)
                            Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Amount (UGX)',
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
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9.,]+')),
                                      ],
                                      onChanged: (value) => {
                                        setState(() {
                                          ++change;
                                        })
                                      },
                                      decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          hintText: "5000000",
                                          hintStyle: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          filled: true),
                                    ),
                                  ],
                                ),
                                addVerticalSpace(5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Loan time (Months)',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 1.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextFormField(
                                        controller: _months,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9.,]+')),
                                        ],
                                        onChanged: (value) => {
                                              setState(() {
                                                ++change;
                                              })
                                            },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return "* Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        // onSaved: (String password) {
                                        // this._password = password;
                                        //},

                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            hintText: "3",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                            filled: true)),
                                  ],
                                ),
                                addVerticalSpace(5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Interest per month(%)',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 1.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextFormField(
                                        controller: _rate,
                                        onChanged: (value) => {
                                              setState(() {
                                                ++change;
                                              })
                                            },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return "* Required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        // onSaved: (String password) {
                                        // this._password = password;
                                        //},
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9.,]+')),
                                        ],
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            hintText: "3.5",
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                            filled: true)),
                                  ],
                                ),
                                addVerticalSpace(5),
                                Text(
                                  _amount.text.isNotEmpty &&
                                          _months.text.isNotEmpty &&
                                          _rate.text.isNotEmpty
                                      ? 'Monthly pay: ${ReturnCoputation().toString()} shs'
                                      : "Monthly pay not computed yet",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                addVerticalSpace(10),
                                addVerticalSpace(5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Fine rate per month(%)',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextFormField(
                                              controller: _pen,
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return "* Required";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              // onSaved: (String password) {
                                              // this._password = password;
                                              //},
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9.,]+')),
                                              ],
                                              decoration: const InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blueGrey),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  hintText: "4.5",
                                                  hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                  filled: true)),
                                        ],
                                      ),
                                    ),
                                    addHorizontalSpace(4),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Fine computed on',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          addVerticalSpace(2),
                                          DropdownButton<String>(
                                            value: selectedPenOn,
                                            icon: const Icon(
                                                Icons.arrow_downward),
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: Container(
                                              height: 2,
                                              color: Colors.blueGrey,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedPenOn = newValue!;
                                              });
                                            },
                                            items: _pen_on
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                addVerticalSpace(5),
                                const Text(
                                  "Note: All officers are considered to have approved this loan",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                addVerticalSpace(10),
                                if (loading)
                                  Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      backgroundColor: Colors.blueGrey,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.yellow),
                                    ),
                                  )
                                else
                                  Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          minimumSize: const Size(350, 50),
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          // send loan
                                          _addloan(
                                              _amount.text,
                                              _months.text,
                                              _pen.text,
                                              _rate.text,
                                              "Custom",
                                              context);
                                        } else {
                                          showText("Fill the fields correctly");
                                        }
                                      },
                                      child: const Text(
                                        "Add Loan",
                                        style: TextStyle(
                                            fontSize: 20, color: COLOR_WHITE),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                        ],
                      )),
                ),
              ]),
        ),
      ),
    ));
  }
}
