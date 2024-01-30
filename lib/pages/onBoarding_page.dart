import 'package:dots_indicator/dots_indicator.dart';
import 'package:finance_app/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  ValueNotifier<int> page = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (page.value == 0)
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: Image.asset('assets/first_onBoarding.png'),
            ),
          if (page.value == 1)
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: Image.asset('assets/second_onBoarding.png'),
            ),
          if (page.value == 2)
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: Image.asset('assets/third_onBoarding.png'),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 20, 11, 11),
            child: Column(children: [
              if (page.value == 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Welcome to our app!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              if (page.value == 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Calculate cash inflows effortlessly. Enter the amount, select the type, and the period. Stay on top of your budget with us!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              if (page.value == 1)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Planning to buy a home? ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              if (page.value == 1)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    'Calculate your mortgage loan instantly. Specify the amount, term, and interest rate. Start your journey to homeownership!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              if (page.value == 2)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Stay informed with financial news!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              if (page.value == 2)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Text(
                    'Read current articles on events in the world of finance. Make informed decisions with our app. Join us and manage your finances with pleasure!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: page,
                      builder: (context, index, child) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DotsIndicator(
                          dotsCount: 3,
                          position: page.value,
                          decorator: DotsDecorator(
                            size: const Size(20.0, 6.0),
                            activeSize: const Size(40.0, 6.0),
                            spacing: const EdgeInsets.all(3),
                            activeColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 20, 40),
                child: InkWell(
                  onTap: () {
                    if (page.value == 0) {
                      page.value = 1;
                      setState(() {});
                    } else if (page.value == 1) {
                      page.value = 2;
                      setState(() {});
                    } else if (page.value == 2) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const HomePage()),
                      );
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.only(top: 13),
                      decoration: BoxDecoration(
                          color: const Color(0xFF6F6CD9),
                          borderRadius: BorderRadius.circular(140)),
                      child: const Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Terms of use  |  Privacy Policy',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.3),
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }

  Widget getStars() {
    List<Widget> list = [];
    for (var i = 0; i < 5; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 16,
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
