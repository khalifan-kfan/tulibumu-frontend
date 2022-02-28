import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tulibumu/utils/widget_functions.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _State_ createState() => _State_();
}

class _State_ extends State<UserPage> {
  final String back = 'assets/svgs/back.svg';

  List<Map<String, dynamic>> images = [
    {
      "id": "011",
      "fullname": "Muwonge khalifan",
      "role": "member",
      "contact": "0707098765"
    },
    {
      "id": "011",
      "fullname": "Muwonge khalifan",
      "role": "member",
      "contact": "0707098765"
    },
    {
      "id": "011",
      "fullname": "Muwonge khalifan",
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
      "fullname": "Khali jk",
      "role": "member",
      "contact": "0707098965"
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
                        images.length.toString(),
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
                Expanded(
                  child: Padding(
                      padding: sidePadding,
                      child: ListView.separated(
                        itemBuilder: (BuildContext, index) {
                          return UserItem(
                            record: images[index],
                            prog: false,
                            index: index,
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
                  record["fullname"],
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
                  onTap: () {},
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
