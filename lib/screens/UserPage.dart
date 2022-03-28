import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tulibumu/screens/UserLoans.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:tulibumu/utils/widget_functions.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _State_ createState() => _State_();
}

class _State_ extends State<UserPage> {
  final String back = 'assets/svgs/back.svg';
  bool loading = false;
  String all_msg = "";
  List<dynamic> AllUsers = [];
  @override
  void initState() {
    AUsers();
    super.initState();
  }

  Future<void> AUsers() async {
    String url = '$BaseUrl/api/users/all/';

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
            AllUsers = AllUsers + parsed["data"];
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
                      'Users',
                      textAlign: TextAlign.start,
                      style: themeData.textTheme.headline1,
                    ),
                  ]),
              addVerticalSpace(5),
              Padding(
                padding: sidePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:",
                      style: themeData.textTheme.headline2,
                    ),
                    Text(
                      AllUsers.length.toString(),
                      style: themeData.textTheme.headline1,
                    ),
                  ],
                ),
              ),
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
              else if (AllUsers.length > 0 && all_msg.isEmpty)
                Expanded(
                  child: Padding(
                      padding: sidePadding,
                      child: ListView.separated(
                        itemBuilder: (BuildContext, index) {
                          return UserItem(
                            record: AllUsers[index],
                            prog: false,
                            index: index,
                          );
                        },
                        itemCount: AllUsers.length,
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

class UserItem extends StatelessWidget {
  final dynamic record;
  final bool prog;
  final index;
  const UserItem({Key? key, this.record, required this.prog, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      child: Row(children: [
        Expanded(
            flex: 1,
            child: Text(
              (index + 1).toString(),
              textAlign: TextAlign.start,
              style: themeData.textTheme.subtitle1,
            )),
        Expanded(
          flex: 9,
          child: Container(
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: COLOR_BACK_GROUND,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.black),
            ),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: Text(
                  record["fullName"],
                  textAlign: TextAlign.start,
                  style: themeData.textTheme.bodyText1,
                ),
              ),
              addHorizontalSpace(5),
              Expanded(
                flex: 3,
                child: Text(
                  record["contact"],
                  textAlign: TextAlign.start,
                  style: themeData.textTheme.subtitle1,
                ),
              ),
              addHorizontalSpace(5),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserLoans(
                              user__: record,
                            )));
                  },
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      color: COLOR_CLICK_GREEN,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    child: Text(
                      "loans",
                      textAlign: TextAlign.center,
                      style: themeData.textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
