import 'dart:convert';

import 'package:finance_app/model/user.dart';
import 'package:finance_app/pages/show_screen.dart';
import 'package:finance_app/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserItem user = UserItem();

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.callBack});
  final Function() callBack;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController textControllerUserName = TextEditingController();
  TextEditingController textControllerEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 60, 18, 43),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    Image.asset('assets/account.png')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFE8F3EA)),
                  child: Row(children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: 57,
                            width: 57,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/user_icon.png',
                                    )),
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        user.name == null
                                            ? 'UserName'
                                            : user.name!,
                                        style: const TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  user.userEmail == null
                                      ? 'useremail@gmail.com'
                                      : user.userEmail!,
                                  style: const TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  content: Card(
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Enter your nickname',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'SrbijaSans-Regular',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextField(
                                            style: const TextStyle(
                                                fontFamily:
                                                    'SrbijaSans-Regular',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                            controller: textControllerUserName,
                                            decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.0),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide:
                                                        BorderSide(width: 1)),
                                                label: Text('Nickname ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'SF Pro Text',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text('Enter your email',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'SrbijaSans-Regular',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextField(
                                            style: const TextStyle(
                                                fontFamily:
                                                    'SrbijaSans-Regular',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                            controller: textControllerEmail,
                                            decoration: const InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.0),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    borderSide:
                                                        BorderSide(width: 1)),
                                                label: Text('Email ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'SF Pro Text',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500))),
                                          ),
                                        ]),
                                  ),
                                  actions: [
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'SF Pro Text',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15))),
                                            InkWell(
                                                onTap: () {
                                                  user.userEmail =
                                                      textControllerEmail.text;
                                                  user.name =
                                                      textControllerUserName
                                                          .text;
                                                  addToSP(user);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'SF Pro Text',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15)))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        decoration: BoxDecoration(
                            color: const Color(0xFF6F6CD9),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ReadTermsOrPrivacyScreenView(
                                link: 'google.com',
                              )),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF3),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(children: [
                      Image.asset('assets/privacy.png'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Privacy policy',
                        style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8EEF3),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(children: [
                    Image.asset('assets/rate.png'),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'Rate app',
                      style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8EEF3),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(children: [
                    Image.asset('assets/share.png'),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'Share app',
                      style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ReadTermsOrPrivacyScreenView(
                                link: 'google.com',
                              )),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF3),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(children: [
                      Image.asset('assets/terms.png'),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Terms of use',
                        style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          )),
        ),
        BottomBar(
          callBack: () {
            Navigator.pop(context);
            widget.callBack();
          },
        )
      ]),
    );
  }

  Future<void> addToSP(
    UserItem? user,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    if (user != null) {
      prefs.setString('user', jsonEncode(user));
    }
  }
}
