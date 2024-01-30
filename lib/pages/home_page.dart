import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:finance_app/model/Income_item.dart';
import 'package:finance_app/model/calculate_mortage.dart';
import 'package:finance_app/model/expense_item.dart';
import 'package:finance_app/model/news_item.dart';
import 'package:finance_app/model/user.dart';
import 'package:finance_app/pages/add_incomes_expenses_page.dart';
import 'package:finance_app/pages/description_news_page.dart';
import 'package:finance_app/pages/user_page.dart';
import 'package:finance_app/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:table_calendar/table_calendar.dart';

EPageOnSelect page = EPageOnSelect.homePage;

enum EMortagePage { mortageCalculator, mortageResult }

enum ETypeOfPayment {
  annuities("Annuities"),
  differentiated("Differentiated");

  const ETypeOfPayment(this.text);
  final String text;
}

enum EMortageTerm {
  oneYear(1),
  twoYears(2),
  threeYears(3),
  fiveYears(5),
  tenYears(10),
  fifteenYears(15),
  twentyYears(20),
  twentyFiveYears(25),
  thirtyYears(30);

  const EMortageTerm(this.text);
  final int text;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IncomeItem> incomes = [];
  List<ExpenseItem> expenses = [];
  TextEditingController realEstateController = TextEditingController();
  TextEditingController initialContributionController = TextEditingController();
  TextEditingController interestRateController = TextEditingController();
  DateTime currentDate = DateTime.now();
  ETypeOfPayment? currentSelectedTypeOfPayment;
  EMortageTerm? currentSelectedMortageTerm;
  List<ETypeOfPayment> typeOfPayment = [
    ETypeOfPayment.annuities,
    ETypeOfPayment.differentiated,
  ];
  List<EMortageTerm> mortagePayment = [
    EMortageTerm.oneYear,
    EMortageTerm.twoYears,
    EMortageTerm.threeYears,
    EMortageTerm.fiveYears,
    EMortageTerm.tenYears,
    EMortageTerm.fifteenYears,
    EMortageTerm.twentyYears,
    EMortageTerm.twentyFiveYears,
    EMortageTerm.thirtyYears,
  ];
  int tagNumber = 0;
  EMortagePage mortagePage = EMortagePage.mortageCalculator;
  List<String> options = [
    'All',
    'Recent',
    'Popular',
    'Interestings',
  ];
  List<NewsItem> newsList = [
    NewsItem(
      title: 'US economic expansion likely hinges on a nimble Fed this time',
      author: 'Howard Schneider',
      type: ENewsType.recent,
      text:
          'WASHINGTON (Reuters) - It took a stock market crash, a housing crash and a pandemic to kill the last three U.S. economic expansions. But of all the risks facing a resilient economy right now, the Federal Reserve may top the list, as U.S. central bankers debate when to lower the restrictive interest rates used to beat inflation that now seems to be in steady decline. Fed officials have signaled a coming pivot towards lower rates sometime this year to avoid pushing too hard on an economy that is outperforming expectations but which many analysts worry has become too dependent on spending by households that are showing signs of stress and on job growth in a narrow set of industries that masks otherwise-stalled hiring. With annualized inflation running beneath the Fed\'s 2% target for seven months, some formulas referred to by officials are pointing to rate cuts sooner than later. Economists, meanwhile, have begun noting the risks of the Fed either falling behind a possible slowdown or of failing to account for the chance the economy may be able to sustain faster growth and more employment than thought without a new surge in prices. "There is still risk out there that there is a short and shallow recession" in the coming year, said Dana Peterson, the chief economist of the Conference Board. CEOs who participated in a recent survey by the business group continued to cite recession as a top risk for the year, while the board\'s Leading Economic Index also points in that direction.',
      date: '01/29/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/QU02.4SD1krsXjlRGUY5zA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQ3MA--/https://media.zenfs.com/en/reuters-finance.com/abc17090e47a5654f6104f9422eeb32b',
    ),
    NewsItem(
      title: 'Oil Erases Gain as Traders Digest Latest Mideast Escalation',
      author: 'Serene Cheong',
      type: ENewsType.recent,
      text:
          'Brent crude was little changed after jumping as much as 1.5% in early Asian trading. Prices on Friday closed at the highest level since November. The White House said Iranian-backed militants killed three soldiers and wounded others in a drone assault, while Tehran sought to distance itself from the attack. That followed a Houthi missile strike Friday on a vessel operated on behalf of Trafigura Group carrying Russian fuel, the most significant yet on an energy-carrying ship. The incidents mark the latest sign of flaring tensions in a region that accounts for about a third of the world’s crude output. “It was a weekend of significant escalation,” said Keshav Lohiya, founder of consultant Oilytics. “The big wild card remains, what will the US response be?” Read More: Here’s What Analysts Say About Oil After Middle East Attacks The deaths of American troops, the first under enemy attack since Israel and Hamas went to war, puts President Joe Biden under intensifying pressure to confront Iran directly, risking a wider conflict in a region vital for global trade. Biden vowed retaliation, though it’s not clear what it will be. The Houthi attack on the tanker was consequential as shippers had previously assumed the safe passage of vessels tied to Russia and China. The militant group previously targeted ships linked to Israel, US and UK primarily.',
      date: '01/29/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/Tfb3rarD2BK.CQKjov1hCw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQ2OQ--/https://media.zenfs.com/en/bloomberg_markets_842/5bbcdc3160e443f3c450dbfaa3f1beaa',
    ),
    NewsItem(
      title: 'Bluebell Asks BP to Bolster Oil and Gas, Cut Renewables Bets',
      author: 'Nishant Kumar ',
      type: ENewsType.recent,
      text:
          'BP should spend \$1.5 billion a year more through 2030 on oil and gas production and halt any further investment in renewables and power, the London-based investment firm said in an October letter to Chairman Helge Lund that was seen by Bloomberg. It reiterated its demands in another letter on Jan. 26. The activist campaign adds to pressure on BP’s new chief executive officer, Murray Auchincloss, named this month to replace the architect of the strategy shift, Bernard Looney. Bluebell, known for agitating for change at Danone SA, said it would have called for Looney’s resignation had he not left in September after admitting he’d failed to fully disclose past relationships with colleagues. BP’s strategy is flawed because the company is aiming to cut fossil fuel output to support a global objective of having net zero carbon emissions by 2050, a policy goal that is increasingly unrealistic, the hedge fund said. “BP is preparing to operate in a world that BP should know will not exist,” Bluebell’s co-founders, Giuseppe Bivona and Marco Taricco, wrote in the October letter. The firm urged the company to reduce cumulative investment in bioenergy, hydrogen and renewables & power by \$28 billion through 2030.',
      date: '01/29/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/sXDFdNNu66BXdFS4phOoQg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQ3MA--/https://media.zenfs.com/en/bloomberg_markets_842/5a47d29b0d82a172e1c5eabac7c60552',
    ),
    NewsItem(
      title:
          'Thai economy in recession, needs a boost -deputy Finance Minister',
      author: 'Kitiphong Thaichareon ',
      type: ENewsType.recent,
      text:
          'BANGKOK (Reuters) -Thailand\'s economy is in a state of recession owing to a high level of household debt, a deputy finance minister said on Monday, raising pressure on the central bank to cut interest rates. Deputy Finance Minister Julapun Amornvivat also said the government was committed to delivering on its signature 500 billion baht (\$14 billion) handout plan of transferring 10,000 baht (\$281) each to 50 million Thais, and hoped a delay in its rollout would not be long. He said the country\'s policy interest rate, which is at a decade-high of 2.50%, should be cut at the central bank\'s next policy review on Feb. 7 to help lower high borrowing costs. "The rate should be lowered as high rates now are people\'s burden. People can\'t survive," he told reporters. Prime Minister Srettha Thavisin has also urged the central bank to cut the key rate to help Southeast Asia\'s second-largest economy he says is in crisis. Bank of Thailand Governor Sethaput Suthiwartnarueput, who has come under fire from the premier for not cutting rates despite negative inflation, told Reuters last week growth had been slower than expected but the economy was not in crisis. Sethaput said the current policy rate was "broadly neutral". The central bank left its policy rate unchanged at 2.50% at its last rate meeting in November, having raised it by 200 basis points since August 2022 to curb inflation.',
      date: '01/29/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/rtjg6UVduULPY5xaXIbWzg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQ3MA--/https://media.zenfs.com/en/reuters-finance.com/ccba781571e2b41f7f0256eb33af9db7',
    ),
    NewsItem(
      title: 'A Year of Bad Inflation Forecasts Casts Doubt on BOE Rate Path',
      author: 'Tom Rees',
      type: ENewsType.popular,
      text:
          'Not once in the past year did the consensus estimate of economists match the figure reported by the Office for National Statistics, the worst record in the Group of Seven economies, an analysis of Bloomberg surveys shows. For four months of 2023, inflation fell outside the range of estimates predicted by the group of UK forecasters, also under-performing the rest of the G-7. The trend has serious ramifications for policy makers and investors, triggering sharper market reactions to data and leaving less certainty that price pressures are on the downward path. It’s likely to make BOE Governor Andrew Bailey more cautious than colleagues at the US Federal Reserve and European Central Bank in signaling that inflation is being contained when the UK central bank delivers its next interest rate decision on Feb. 1. The BOE is trying to judge whether a swifter cooling in inflationary pressures is playing out ahead of its policy meeting on Thursday. It comes after the two most recent inflation releases that surprised economists and could usher in a change in approach if the central bank can be confident the data does signal a marked easing.',
      date: '01/29/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/EvHtm7iCUgNzElfiZA2EaA--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQzNA--/https://media.zenfs.com/en/bloomberg_markets_842/c4aafc16011cb4a31ee8534416188696',
    ),
    NewsItem(
      title: 'Biden Adviser Sees Limited Inflation Impact From Red Sea Attacks',
      author: 'Tony Czuczka',
      type: ENewsType.interesting,
      text:
          'Cost pressures have been more on logistics than on energy commodities, Amos Hochstein said on CBS’s Face the Nation on Sunday. “The costs do go up,” Hochstein said. “But if you look at what they impact, the inflationary impacts are relatively muted.” Two months of missile, drone and hijacking attacks against civilian ships in the Red Sea have caused the biggest diversion of international trade in decades, pushing up global shipping costs and forcing hundreds of cargo ships to take alternative routes. Yet oil prices are lower than on Oct. 7 when an attack by Hamas militants on Israel triggered a war between the two sides. “We’re going to continue to work to mitigate and degrade the efforts that the Houthis have to attack,” Hochstein said. Read more: Houthi Hit on Russian Fuel Has Oil Traders Recalculating Risks A tanker operated on behalf of trading giant Trafigura Group carrying a cargo of Russian fuel was hit in a Houthi missile attack in the Gulf of Aden on Friday, marking the most significant attack yet by the rebel group on an oil-carrying vessel. Tanker traffic in the region has declined since joint US and UK airstrikes on the Houthis this month, but some oil exporters, including Saudi Arabia, continue to use the waterway.',
      date: '01/29/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/Qv8lu_cwMfRvloJSluC05A--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQ3MA--/https://media.zenfs.com/en/bloomberg_markets_842/78cc16e7ed257e64e78dac4f54f63cae',
    ),
    NewsItem(
      title: 'Fed Rate Decision Could Be the Prelude to a March Cut',
      author: 'Matthew Boesler',
      type: ENewsType.popular,
      text:
          'Going into this week’s two-day policy meeting, which wraps Wednesday afternoon in Washington, investors are assigning roughly even odds to the prospect that the US central bank will start lowering borrowing costs at its next decision in March. That makes Fed Chair Jerome Powell’s press conference, and any signal he may or may not choose to send, of critical importance. It all comes down to how Powell and his colleagues have been reading the recent spate of economic data. On one hand, inflation numbers continue to surprise to the downside. The Fed’s preferred gauge decelerated to 2.9% in December, crossing below 3% for the first time since early 2021, according to data published Friday. On the other, consumer spending continues to be surprisingly robust. It’s undoubtedly getting a boost from the downdraft in inflation, but the strength still may keep some worried that price pressures could mount once again. What Bloomberg Economics Says: “The stage is set for the Fed to take steps toward cutting rates in coming months. We expect the Fed to begin lowering the federal funds rate target range in March as it attempts to stick a soft landing.”',
      date: '01/28/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/fZfIVLiESoHSmXeegB2z2w--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTM5Nw--/https://media.zenfs.com/en/bloomberg_markets_842/9c4326fe720c7dd099741f59b768329d',
    ),
    NewsItem(
      title:
          'Don’t have a college education and want to make bank and take half the year off? Oil rig work is the hot job for many Americans',
      author: 'Sunny Nagpaul',
      type: ENewsType.interesting,
      text:
          'Not many on-the-ground jobs  that offer a salary over \$55,000 for just half a year’s work. But that’s the money for those who opt for the rigor of an oil rig,  a hot topic on people’s tongues this week. According to Google, interest in oil rig jobs is having a moment. Searches for oil rig work reached a five-year high, surging particularly especially in the southern states of Mississippi, Alabama, Texas and Arkansas, which abut the Gulf of Mexico and its 6,000-plus oil and gas structures, or rigs. A few reasons help explain why more people want in on the job despite deadly on-the-clock risks and increased environmental pollution. Good money; no college required. According to research on the impact of oil and gas job opportunities, most jobs in the industry pay well, especially for those who don’t have college degrees. Entry-level oil work only requires a high school diploma or equivalent, which could be tempting for more than half of all Americans over age 25 who don’t have a college degree. Starting salaries average \$55,000 per year, according to ZipRecruiter, while those in management positions could pocket well over \$100,000 per year, according to oil industry law firm Arnold & Itkin. According to Amanda Chuan, a professor in labor relations at Michigan State University, the attractive starting pay especially entices college-aged young men, who account for about 20% of the workforce, and are increasingly facing decisions between enrolling in school and risking years of debt and taking a high starting salary that they could pocket much sooner.',
      date: '01/27/2024',
      image:
          'https://s.yimg.com/ny/api/res/1.2/mw9pb_S5NZUMwkk2E_Yn4A--/YXBwaWQ9aGlnaGxhbmRlcjt3PTcwNTtoPTQ3MA--/https://media.zenfs.com/en/fortune_175/f3d6e3f3d9639459c3f9513f48d14226',
    )
  ];
  ENewsType filterType = ENewsType.all;
  double mounthlyPayment = 0.0;
  CalculateMortage lastMortage = CalculateMortage();
  CalculateMortage toMortagePage = CalculateMortage();
  @override
  void initState() {
    super.initState();
    getSP();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: getContent(),
      ),
    );
  }

  Widget getContent() {
    if (page == EPageOnSelect.homePage) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 60, 18, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name == null
                      ? 'Hi!\nWelcome back'
                      : user.name!.isEmpty
                          ? 'Hi!\nWelcome back'
                          : 'Hi, ${user.name}.\nWelcome back',
                  style: const TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => UserPage(
                                  callBack: () {
                                    setState(() {});
                                  },
                                )),
                      );
                    },
                    child: Image.asset('assets/account.png'))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(13, 21, 13, 21),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 15.0,
                              spreadRadius: 5.0,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                            )
                          ]),
                      child: Row(children: [
                        Image.asset('assets/Currency_Crush.png'),
                        const SizedBox(
                          width: 18,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image.asset('assets/wallet.png'),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      page = EPageOnSelect.operationsPage;
                                      setState(() {});
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your incomes',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          incomes.isEmpty
                                              ? '\$0.00'
                                              : getIncomesString(),
                                          style: const TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF6F6CD9),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image.asset('assets/wallet.png'),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      page = EPageOnSelect.operationsPage;
                                      setState(() {});
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your expenses',
                                          style: TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          expenses.isEmpty
                                              ? '\$0.00'
                                              : getExpenseString(),
                                          style: const TextStyle(
                                              fontFamily: 'SF Pro Text',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF6F6CD9),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset('assets/statistics.png'),
                                const SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (lastMortage.accruedInterest != null) {
                                      page = EPageOnSelect.mortagePage;
                                      mortagePage = EMortagePage.mortageResult;
                                      toMortagePage = lastMortage;
                                      setState(() {});
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last calculate',
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        lastMortage.mountlyPayment != null
                                            ? '\$${lastMortage.mountlyPayment!.toStringAsFixed(2)}'
                                            : '\$0.00',
                                        style: const TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF6F6CD9),
                                )
                              ],
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 16, left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Last news',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: getNews2(),
                  )
                ],
              ),
            ),
          ),
          BottomBar(
            callBack: () {
              setState(() {});
            },
          ),
        ],
      );
    } else if (page == EPageOnSelect.operationsPage) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 60, 18, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operations',
                  style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => UserPage(
                                  callBack: () {
                                    setState(() {});
                                  },
                                )),
                      );
                    },
                    child: Image.asset('assets/account.png'))
              ],
            ),
          ),
          if (incomes.isNotEmpty || expenses.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 43,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: const Color(0xFFdddcf6),
                    ),
                    child: TabBar(
                      padding: const EdgeInsets.all(2),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: Colors.white,
                      ),
                      tabs: const [
                        Tab(
                          text: 'Incomes',
                        ),
                        Tab(
                          text: 'Expenses',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: TabBarView(
              children: [
                incomes.isNotEmpty
                    ? SingleChildScrollView(child: getIncomes())
                    : expenses.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 120, bottom: 28),
                                  child: Image.asset(
                                      'assets/operations_image.png'),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 68),
                                  child: Text(
                                    'Add your incomes to track your history',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 120, bottom: 28),
                                  child: Image.asset(
                                      'assets/operations_image.png'),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 68),
                                  child: Text(
                                    'Add your expenses and incomes to track your history',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                expenses.isNotEmpty
                    ? getExpenses()
                    : incomes.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 120, bottom: 28),
                                  child: Image.asset(
                                      'assets/operations_image.png'),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 68),
                                  child: Text(
                                    'Add your expenses to track your history',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 120, bottom: 28),
                                  child: Image.asset(
                                      'assets/operations_image.png'),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 68),
                                  child: Text(
                                    'Add your expenses and incomes to track your history',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
              ],
            ),
          ),
          Column(
            children: [
              if (page == EPageOnSelect.operationsPage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    AddIncomesExpensesPage(
                                      callBackIncome: (income) {
                                        incomes.add(income);
                                        addToSP(expenses, incomes, user,
                                            lastMortage);
                                        setState(() {});
                                      },
                                      callBackExpense: (expense) {
                                        expenses.add(expense);
                                        addToSP(expenses, incomes, user,
                                            lastMortage);
                                        setState(() {});
                                      },
                                    )),
                          );
                        },
                        child: Container(
                          height: 56,
                          width: 56,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                              color: Color(0xFFE8F3EA), shape: BoxShape.circle),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF6F6CD9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              BottomBar(
                callBack: () {
                  setState(() {});
                },
              ),
            ],
          )
        ],
      );
    } else if (page == EPageOnSelect.mortagePage) {
      return mortagePage == EMortagePage.mortageCalculator
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 60, 18, 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mortgage calculator',
                        style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) => UserPage(
                                        callBack: () {
                                          setState(() {});
                                        },
                                      )),
                            );
                          },
                          child: Image.asset('assets/account.png'))
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Real estate value, \$',
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            controller: realEstateController,
                            style: const TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6F6CD9), width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6F6CD9), width: 1.5),
                              ),
                            ),
                            onEditingComplete: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Initial contribution, \$',
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            controller: initialContributionController,
                            style: const TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6F6CD9), width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color(0xFF6F6CD9), width: 1.5),
                              ),
                            ),
                            onEditingComplete: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mortage term',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormField<EMortageTerm>(
                                  builder:
                                      (FormFieldState<EMortageTerm> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF6F6CD9),
                                              width: 1.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF6F6CD9),
                                              width: 1.5),
                                        ),
                                      ),
                                      isEmpty:
                                          currentSelectedTypeOfPayment == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<EMortageTerm>(
                                          value: currentSelectedMortageTerm,
                                          isDense: true,
                                          onChanged: (EMortageTerm? newValue) {
                                            setState(() {
                                              currentSelectedMortageTerm =
                                                  newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items: mortagePayment
                                              .map((EMortageTerm value) {
                                            return DropdownMenuItem<
                                                EMortageTerm>(
                                              value: value,
                                              child: Text(
                                                  value.text == 1
                                                      ? '${value.text.toString()} year'
                                                      : '${value.text.toString()} years',
                                                  style: const TextStyle(
                                                      fontFamily: 'SF Pro Text',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Interest rate, %',
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: interestRateController,
                                  style: const TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF6F6CD9), width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF6F6CD9), width: 1.5),
                                    ),
                                  ),
                                  onEditingComplete: () {
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                mounthlyPayment = 0.0;
                                CalculateMortage mortage = CalculateMortage();
                                if (num.tryParse(interestRateController.text) !=
                                        null &&
                                    num.tryParse(realEstateController.text) !=
                                        null &&
                                    currentSelectedMortageTerm != null &&
                                    num.tryParse(initialContributionController
                                            .text) !=
                                        null) {
                                  double interestRate =
                                      num.tryParse(interestRateController.text)!
                                              .toDouble() /
                                          100 /
                                          12;
                                  mounthlyPayment = ((num.tryParse(
                                                  realEstateController.text)!
                                              .toDouble() -
                                          num.tryParse(
                                                  initialContributionController
                                                      .text)!
                                              .toDouble()) *
                                      ((interestRate *
                                              pow(
                                                  (1 + interestRate),
                                                  currentSelectedMortageTerm!
                                                          .text *
                                                      12)) /
                                          (pow(
                                                  (1 + interestRate),
                                                  currentSelectedMortageTerm!
                                                          .text *
                                                      12) -
                                              1)));

                                  //Last mortage
                                  mortage.creditAmount =
                                      num.tryParse(realEstateController.text)!
                                              .toDouble() -
                                          num.tryParse(
                                                  initialContributionController
                                                      .text)!
                                              .toDouble();
                                  mortage.accruedInterest = ((mounthlyPayment *
                                          currentSelectedMortageTerm!.text *
                                          12) -
                                      (num.tryParse(realEstateController.text)!
                                              .toDouble() -
                                          num.tryParse(
                                                  initialContributionController
                                                      .text)!
                                              .toDouble()));
                                  mortage.mountlyPayment = mounthlyPayment;
                                  mortage.mortageTerm =
                                      currentSelectedMortageTerm!.text;
                                  mortage.debtInterest = ((mounthlyPayment *
                                      currentSelectedMortageTerm!.text *
                                      12));
                                  lastMortage = mortage;
                                  addToSP(expenses, incomes, user, mortage);

                                  mortagePage = EMortagePage.mortageResult;
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: 256,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF6F6CD9),
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Text(
                                  'Calculate',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'SF Pro Text',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))),
                BottomBar(
                  callBack: () {
                    setState(() {});
                  },
                ),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 60, 18, 25),
                  child: InkWell(
                    onTap: () {
                      mortagePage = EMortagePage.mortageCalculator;
                      setState(() {});
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFE8EEF3),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'Credit amount',
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            color: Color(0xFF6F6CD9),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      toMortagePage.creditAmount != null
                                          ? '${toMortagePage.creditAmount!.toStringAsFixed(0)} \$'
                                          : '${((num.tryParse(realEstateController.text)!.toDouble() - num.tryParse(initialContributionController.text)!.toDouble())).toStringAsFixed(0)} \$',
                                      style: const TextStyle(
                                          fontFamily: 'SF Pro Text',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 19,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'Accrued interest',
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            color: Color(0xFFD96C6C),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      toMortagePage.accruedInterest != null
                                          ? '${toMortagePage.accruedInterest!.toStringAsFixed(0)} \$'
                                          : '${((mounthlyPayment * currentSelectedMortageTerm!.text * 12) - (num.tryParse(realEstateController.text)!.toDouble() - num.tryParse(initialContributionController.text)!.toDouble())).toStringAsFixed(0)} \$',
                                      style: const TextStyle(
                                          fontFamily: 'SF Pro Text',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 19,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'Monthly payment',
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            fontSize: 18,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      toMortagePage.mountlyPayment != null
                                          ? '${toMortagePage.mountlyPayment!.toStringAsFixed(0)} \$'
                                          : '${mounthlyPayment.toStringAsFixed(0)} \$',
                                      style: const TextStyle(
                                          fontFamily: 'SF Pro Text',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 19,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'Debt + interest',
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      toMortagePage.debtInterest != null
                                          ? '${toMortagePage.debtInterest!.toStringAsFixed(0)} \$'
                                          : '${((mounthlyPayment * currentSelectedMortageTerm!.text * 12)).toStringAsFixed(0)} \$',
                                      style: const TextStyle(
                                          fontFamily: 'SF Pro Text',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE8F3EA),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: PieChart(
                                          colorList: const [
                                            Color(0xFF6F6CD9),
                                            Color(0xFFD96C6C)
                                          ],
                                          chartValuesOptions:
                                              const ChartValuesOptions(
                                                  showChartValuesInPercentage:
                                                      true,
                                                  decimalPlaces: 1,
                                                  chartValueStyle: TextStyle(
                                                      fontFamily: 'SF Pro Text',
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  chartValueBackgroundColor:
                                                      Colors.transparent),
                                          legendOptions: const LegendOptions(
                                            showLegends: false,
                                            showLegendsInRow: false,
                                          ),
                                          dataMap: toMortagePage.creditAmount !=
                                                  null
                                              ? {
                                                  toMortagePage.creditAmount!
                                                          .toStringAsFixed(0):
                                                      ((toMortagePage
                                                              .creditAmount!) /
                                                          ((toMortagePage
                                                                      .mountlyPayment! *
                                                                  toMortagePage
                                                                      .mortageTerm! *
                                                                  12) *
                                                              100)),
                                                  toMortagePage.accruedInterest!
                                                      .toStringAsFixed(0): ((toMortagePage
                                                          .accruedInterest!) /
                                                      ((toMortagePage
                                                                  .mountlyPayment! *
                                                              toMortagePage
                                                                  .mortageTerm! *
                                                              12) *
                                                          100))
                                                }
                                              : {
                                                  ((((num.tryParse(
                                                                  realEstateController
                                                                      .text)!
                                                              .toDouble() -
                                                          num.tryParse(
                                                                  initialContributionController
                                                                      .text)!
                                                              .toDouble())))
                                                      .toStringAsFixed(
                                                          0)): (((num.tryParse(
                                                                  realEstateController
                                                                      .text)!
                                                              .toDouble() -
                                                          num.tryParse(
                                                                  initialContributionController
                                                                      .text)!
                                                              .toDouble()) /
                                                      (mounthlyPayment *
                                                          currentSelectedMortageTerm!
                                                              .text *
                                                          12) *
                                                      100)),
                                                  (((((mounthlyPayment *
                                                              currentSelectedMortageTerm!
                                                                  .text *
                                                              12) -
                                                          (num.tryParse(realEstateController.text)!
                                                                  .toDouble() -
                                                              num.tryParse(initialContributionController.text)!
                                                                  .toDouble()))))
                                                      .toStringAsFixed(
                                                          0)): ((((mounthlyPayment *
                                                              currentSelectedMortageTerm!
                                                                  .text *
                                                              12) -
                                                          (num.tryParse(realEstateController.text)!
                                                                  .toDouble() -
                                                              num.tryParse(initialContributionController
                                                                      .text)!
                                                                  .toDouble())) /
                                                      (mounthlyPayment *
                                                          currentSelectedMortageTerm!
                                                              .text *
                                                          12) *
                                                      100)),
                                                },
                                          // totalValue: (mounthlyPayment *
                                          //     currentSelectedMortageTerm!.text *
                                          //     12),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF6F6CD9),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Text(
                                        'Credit amount',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: 150,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFD96C6C),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Text(
                                        'Accrued interest',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'SF Pro Text',
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFE8EEF3),
                              borderRadius: BorderRadius.circular(8)),
                          child: TableCalendar(
                            headerStyle: HeaderStyle(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black
                                                .withOpacity(0.1)))),
                                formatButtonVisible: false,
                                titleTextStyle: const TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            calendarStyle: const CalendarStyle(
                              todayTextStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              defaultTextStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              todayDecoration: BoxDecoration(
                                  color: Color(0xFF6F6CD9),
                                  shape: BoxShape.circle),
                            ),
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: DateTime.now(),
                            locale: 'en_US',
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                BottomBar(
                  callBack: () {
                    setState(() {});
                  },
                ),
              ],
            );
    } else if (page == EPageOnSelect.newsPage) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 60, 18, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'News',
                  style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => UserPage(
                                  callBack: () {
                                    setState(() {});
                                  },
                                )),
                      );
                    },
                    child: Image.asset('assets/account.png'))
              ],
            ),
          ),
          ChipsChoice<int>.single(
            choiceStyle: C2ChipStyle.filled(
                borderRadius: BorderRadius.circular(100),
                foregroundStyle: const TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14),
                color: Colors.white,
                backgroundOpacity: 0.15,
                checkmarkColor: Colors.white,
                hoveredStyle: C2ChipStyle.filled(
                  color: const Color(0xFF6F6CD9),
                ),
                selectedStyle: C2ChipStyle.filled(
                    color: const Color(0xFF6F6CD9),
                    foregroundStyle: const TextStyle(
                        fontFamily: 'SF Pro Text',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14))),
            value: tagNumber,
            onChanged: (val) => setState(() => tagNumber = val),
            choiceItems: C2Choice.listFrom<int, String>(
              source: options,
              value: (i, v) => i,
              label: (i, v) => v,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [getNews1()],
                ),
              ),
            ),
          ),
          BottomBar(
            callBack: () {
              setState(() {});
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getIncomes() {
    return StickyGroupedListView<IncomeItem, DateTime>(
      elements: incomes,
      shrinkWrap: true,
      order: StickyGroupedListOrder.ASC,
      groupBy: (IncomeItem element) =>
          DateTime(element.date!.year, element.date!.month, element.date!.day),
      groupSeparatorBuilder: (IncomeItem element) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 9),
        child: Text(
          DateFormat("MMMM dd, yyyy").format(element.date!),
          style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      itemBuilder: (context, element) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF3),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+${element.cost}\$',
                      style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          color: Color(0xFF6F6CD9),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      decoration: BoxDecoration(
                          color: const Color(0xFF6F6CD9),
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        element.type!.text,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }

  Widget getExpenses() {
    return StickyGroupedListView<ExpenseItem, DateTime>(
      elements: expenses,
      shrinkWrap: true,
      order: StickyGroupedListOrder.ASC,
      groupBy: (ExpenseItem element) =>
          DateTime(element.date!.year, element.date!.month, element.date!.day),
      groupSeparatorBuilder: (ExpenseItem element) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 9),
        child: Text(
          DateFormat("MMMM dd, yyyy").format(element.date!),
          style: const TextStyle(
              fontFamily: 'SF Pro Text',
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      itemBuilder: (context, element) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF3),
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+${element.cost}\$',
                      style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          color: Color(0xFF6F6CD9),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      decoration: BoxDecoration(
                          color: element.type == ECategoryType.entertainment
                              ? const Color(0xFFD96CA7)
                              : element.type == ECategoryType.travel
                                  ? const Color(0xFFA96CD9)
                                  : element.type == ECategoryType.food
                                      ? const Color(0xFFD96C6C)
                                      : element.type ==
                                              ECategoryType.financialOperations
                                          ? const Color(0xFF69CD7F)
                                          : const Color(0xFFD9806C),
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        element.type!.text,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ])),
        );
      },
    );
  }

  Widget getNews1() {
    List<Widget> list = [];
    List<NewsItem> filteredNews = [];
    if (tagNumber == 0) {
      filteredNews = newsList;
    } else if (tagNumber == 1) {
      filteredNews = newsList
          .where((element) => element.type == ENewsType.recent)
          .toList();
    } else if (tagNumber == 2) {
      filteredNews = newsList
          .where((element) => element.type == ENewsType.popular)
          .toList();
    } else if (tagNumber == 3) {
      filteredNews = newsList
          .where((element) => element.type == ENewsType.interesting)
          .toList();
    }
    for (var news in filteredNews) {
      list.add(InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (BuildContext context) => DescriptionNewsPage(
                      news: news,
                      newsList: newsList,
                      callBack: () {
                        setState(() {});
                      },
                    )),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFE8EEF3),
              borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  height: 132,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            news.image!,
                          ))),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                news.title!,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Text(
                news.text!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/Avatar.png'),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      news.author!,
                      style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ],
                ),
                const Text(
                  'Read more',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: 12,
                    color: Color(0xFF6F6CD9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ]),
        ),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget getNews2() {
    List<Widget> list = [];

    for (var news in newsList) {
      list.add(InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (BuildContext context) => DescriptionNewsPage(
                      news: news,
                      newsList: newsList,
                      callBack: () {
                        setState(() {});
                      },
                    )),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFE8EEF3),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  height: 112,
                  width: 112,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            news.image!,
                          ))),
                )),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            news.title!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Read more',
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 12,
                              color: Color(0xFF6F6CD9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ));
    }
    return Column(
      children: list,
    );
  }

  Future<void> addToSP(
      List<ExpenseItem>? expensesList,
      List<IncomeItem>? incomeList,
      UserItem? user,
      CalculateMortage? mortage) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    if (user != null) {
      prefs.setString('user', jsonEncode(user));
    }
    if (expensesList != null) {
      prefs.setString('expensesLists', jsonEncode(expensesList));
    }
    if (incomeList != null) {
      prefs.setString('incomeLists', jsonEncode(incomeList));
    }
    if (mortage != null) {
      prefs.setString('mortage', jsonEncode(mortage));
    }
  }

  void getSP() async {
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> jsonData2 =
        jsonDecode(prefs.getString('expensesLists') ?? '[]');
    final List<dynamic> jsonData3 =
        jsonDecode(prefs.getString('incomeLists') ?? '[]');
    if (prefs.getString('user') != null) {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('user')!);
      user = UserItem.fromJson(userMap);
    }
    if (prefs.getString('mortage') != null) {
      Map<String, dynamic> mortageMap = jsonDecode(prefs.getString('mortage')!);

      lastMortage = CalculateMortage.fromJson(mortageMap);
    }

    expenses = jsonData2.map<ExpenseItem>((jsonList) {
      {
        return ExpenseItem.fromJson(jsonList);
      }
    }).toList();
    incomes = jsonData3.map<IncomeItem>((jsonList) {
      {
        return IncomeItem.fromJson(jsonList);
      }
    }).toList();

    setState(() {});
  }

  String getIncomesString() {
    double incomeTotal = 0.0;
    for (var income in incomes) {
      incomeTotal = incomeTotal + income.cost!;
    }
    return '\$${incomeTotal.toStringAsFixed(2)}';
  }

  String getExpenseString() {
    double expenseTotal = 0.0;
    for (var expense in expenses) {
      expenseTotal = expenseTotal + expense.cost!;
    }
    return '\$${expenseTotal.toStringAsFixed(2)}';
  }
}

class WakeFieldReceipt extends StatelessWidget {
  const WakeFieldReceipt({
    super.key,
    required this.wakx,
  });
  final String wakx;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(wakx),
          ),
        ),
      ),
    );
  }
}
