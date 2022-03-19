import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter/services.dart';
import 'package:tulibumu/custom/BorderIcon.dart';
import 'package:tulibumu/main.dart';
//import 'package:tulibumu/screens/SignupPage.dart';
import 'package:tulibumu/screens/Landingpage.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/utils/widget_functions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddLoan extends StatefulWidget {
  const AddLoan({Key? key}) : super(key: key);

  @override
  _addloan createState() => _addloan();
}

class _addloan extends State<AddLoan> {
  TextEditingController _amount = TextEditingController();
  TextEditingController _months = TextEditingController();
  TextEditingController _pen = TextEditingController();
  TextEditingController _rate = TextEditingController();

  List<Map<String, dynamic>> users = [
    {
      "id": "011",
      "fullname": "Muwo khalif gnkkjlh nbhjgjyg",
      "role": "member",
      "contact": "0707098765"
    },
    {
      "id": "011",
      "fullname": "Muwonge khal",
      "role": "member",
      "contact": "0707098765"
    },
    {
      "id": "011",
      "fullname": "Muw khalifanc",
      "role": "member",
      "contact": "0707098765"
    },
    {
      "id": "012",
      "fullname": "Muwonge jk",
      "role": "member",
      "contact": "0707098965"
    },
    {
      "id": "012",
      "fullname": "Khali jk",
      "role": "member",
      "contact": "0707098965"
    },
    {
      "id": "012",
      "fullname": "Khalid jk",
      "role": "member",
      "contact": "0707098965"
    },
  ];

  List<String> _pen_on = ["Monthly pay", "Amount"];
  late String selectedName;
  late String selectedPenOn;
  late List<String> MyNames = BringNames();
  var change = 0;

  double ReturnCoputation() {
    var interest =
        double.parse(_amount.text) * (double.parse(_rate.text) / 100);
    var total =
        (interest * double.parse(_months.text)) + double.parse(_amount.text);
    return (total / double.parse(_months.text));
  }

  List<String> BringNames() {
    List<String> MyNames = [];
    for (int i = 0; i < users.length; i += 1) {
      MyNames.add(users[i]["fullname"]);
    }
    return MyNames;
  }

  _addloan() {
    //print(MyNames);
    selectedName = MyNames[0];
    selectedPenOn = _pen_on[1];
  }

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
                                keyboardType: TextInputType.numberWithOptions(
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
                                          color: Colors.green, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2.0),
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
                                value: selectedName,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.green),
                                underline: Container(
                                  height: 2,
                                  color: Colors.green,
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
                                  keyboardType: TextInputType.numberWithOptions(
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
                                            color: Colors.green, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      hintText: "3",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
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
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]+')),
                                  ],
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      hintText: "3.5",
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
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
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          addVerticalSpace(10),
                          addVerticalSpace(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  color: Colors.green),
                                            ),
                                            enabledBorder: OutlineInputBorder(
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.green),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.green,
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
                            "Note: All officers are considered to have aproved this loan",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          addVerticalSpace(10),
                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  minimumSize: const Size(350, 50),
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  // login
                                  // SignInUser(
                                  //     _contact.text, _pass.text, context);
                                } else {
                                  // showText("Fill the fields correctly");
                                }
                              },
                              child: const Text(
                                "Add Loan",
                                style:
                                    TextStyle(fontSize: 20, color: COLOR_WHITE),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ]),
        ),
      ),
    ));
  }
}
