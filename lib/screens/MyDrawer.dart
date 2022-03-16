import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tulibumu/screens/AddUser.dart';
import 'package:tulibumu/screens/LoginScreen.dart';
import 'package:tulibumu/screens/NewLoanPage.dart';
import 'package:tulibumu/utils/constants.dart';
import 'package:tulibumu/screens/UserPage.dart';
import 'package:tulibumu/screens/AddLoan.dart';

class MyDrawer extends StatelessWidget {
  final String people = 'assets/svgs/people.svg';
  final String usr = 'assets/svgs/users.svg';

  final dynamic user;

  const MyDrawer({Key? key, this.user}) : super(key: key);

  Future<void> ResetUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('fullName');
    //print(await storage.read(key: "token"));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // print(user);
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: COLOR_BACK_GROUND,
            child: Center(
              child: Column(
                children: [
                  LimitedBox(
                    child: SvgPicture.asset(
                      people,
                      color: Colors.black,
                      width: 90,
                      height: 90,
                      theme: const SvgTheme(
                          currentColor: null, fontSize: 14, xHeight: 6),
                    ),
                    maxHeight: 90,
                    maxWidth: 90,
                  ),
                  const Text(
                    "We are one",
                    style: TextStyle(
                      fontSize: 20,
                      color: COLOR_BLACK,
                    ),
                  ),
                  Column(children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name:",
                          textAlign: TextAlign.start,
                          style: themeData.textTheme.bodyText2,
                        ),
                        Text(
                          "Muwonge Khalifan",
                          textAlign: TextAlign.end,
                          style: themeData.textTheme.headline5,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Contact:",
                          textAlign: TextAlign.start,
                          style: themeData.textTheme.bodyText2,
                        ),
                        Text(
                          "070987654",
                          textAlign: TextAlign.end,
                          style: themeData.textTheme.headline5,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Role:",
                          textAlign: TextAlign.start,
                          style: themeData.textTheme.bodyText2,
                        ),
                        Text(
                          "member",
                          textAlign: TextAlign.end,
                          style: themeData.textTheme.headline5,
                        ),
                      ],
                    )
                  ]),
                  const Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: LimitedBox(
              child: SvgPicture.asset(
                usr,
                color: Colors.black,
                width: 20,
                height: 20,
                theme: const SvgTheme(
                    currentColor: null, fontSize: 12, xHeight: 6),
              ),
              maxHeight: 20,
              maxWidth: 20,
            ),
            title: Text(
              "All Users",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              "About us",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(
              "Contact us",
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text(
              "Log out",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () async {
              ResetUser().then((value) => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen())));
            },
          ),
          if (user != null)
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
          if (user!["role"] == "treasurer" || user!["role"] == "admin")
            ListTile(
              title: const Text(
                "New loans",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NewLoanPage()));
              },
            ),
          if (user!["role"] == "admin" || user!["role"] == "officer")
            ListTile(
              title: const Text(
                "Add loan",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddLoan()));
              },
            ),
          if (user!["role"] == "treasurer" ||
              user!["role"] == "officer" ||
              user!["role"] == "admin")
            ListTile(
              title: const Text(
                "Add User",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddUser()));
              },
            ),
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
