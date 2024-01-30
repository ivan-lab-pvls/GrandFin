import 'package:finance_app/pages/home_page.dart';
import 'package:flutter/material.dart';

enum EPageOnSelect {
  homePage,
  operationsPage,
  newsPage,
  mortagePage,
}

class BottomBar extends StatefulWidget {
  const BottomBar(
      {super.key, required this.callBack, this.fromCocktailPage = false});
  final VoidCallback callBack;
  final bool fromCocktailPage;

  @override
  State<BottomBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 15.0,
          spreadRadius: 10.0,
          offset: const Offset(
            5.0,
            5.0,
          ),
        )
      ]),
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              page = EPageOnSelect.homePage;

              widget.callBack();
              setState(() {});
            },
            child: SizedBox(
                height: 50,
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    page == EPageOnSelect.homePage
                        ? Image.asset(
                            'assets/home.png',
                            color: const Color(0xFF6F6CD9),
                          )
                        : Image.asset(
                            'assets/home.png',
                            color:
                                Colors.black.withOpacity(0.4).withOpacity(0.4),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Home',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              color: page == EPageOnSelect.homePage
                                  ? const Color(0xFF6F6CD9)
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 12)),
                    )
                  ],
                )),
          ),
          InkWell(
            onTap: () {
              page = EPageOnSelect.newsPage;

              widget.callBack();
              setState(() {});
            },
            child: SizedBox(
                height: 70,
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    page == EPageOnSelect.newsPage
                        ? Image.asset(
                            'assets/activity.png',
                            color: const Color(0xFF6F6CD9),
                          )
                        : Image.asset(
                            'assets/activity.png',
                            color:
                                Colors.black.withOpacity(0.4).withOpacity(0.4),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('News',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              color: page == EPageOnSelect.newsPage
                                  ? const Color(0xFF6F6CD9)
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 12)),
                    )
                  ],
                )),
          ),
          InkWell(
            onTap: () {
              page = EPageOnSelect.mortagePage;

              widget.callBack();
              setState(() {});
            },
            child: SizedBox(
                height: 50,
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    page == EPageOnSelect.mortagePage
                        ? Image.asset(
                            'assets/statistics.png',
                            color: const Color(0xFF6F6CD9),
                          )
                        : Image.asset(
                            'assets/statistics.png',
                            color:
                                Colors.black.withOpacity(0.4).withOpacity(0.4),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Mortage',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              color: page == EPageOnSelect.mortagePage
                                  ? const Color(0xFF6F6CD9)
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 12)),
                    )
                  ],
                )),
          ),
          InkWell(
            onTap: () {
              page = EPageOnSelect.operationsPage;

              widget.callBack();
              setState(() {});
            },
            child: SizedBox(
                height: 70,
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    page == EPageOnSelect.operationsPage
                        ? Image.asset(
                            'assets/wallet.png',
                            color: const Color(0xFF6F6CD9),
                          )
                        : Image.asset(
                            'assets/wallet.png',
                            color: Colors.black.withOpacity(0.4),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Operations',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w500,
                              color: page == EPageOnSelect.operationsPage
                                  ? const Color(0xFF6F6CD9)
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 12)),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
