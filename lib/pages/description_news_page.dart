import 'package:cached_network_image/cached_network_image.dart';
import 'package:finance_app/model/news_item.dart';
import 'package:finance_app/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class DescriptionNewsPage extends StatefulWidget {
  const DescriptionNewsPage(
      {super.key,
      required this.callBack,
      required this.news,
      required this.newsList});
  final Function callBack;
  final List<NewsItem> newsList;
  final NewsItem news;

  @override
  State<DescriptionNewsPage> createState() => _DescriptionNewsPageState();
}

class _DescriptionNewsPageState extends State<DescriptionNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 60, 18, 25),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8EEF3),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 11),
                          child: Container(
                            height: 178,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        widget.news.image!))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 11),
                          child: Row(
                            children: [
                              Image.asset('assets/Avatar.png'),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.news.author!,
                                style: const TextStyle(
                                    fontFamily: 'SF Pro Text',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            widget.news.title!,
                            style: const TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          widget.news.text!,
                          style: const TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'More news',
                            style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    getMoreNews()
                  ],
                ),
              ),
            ),
          ),
          BottomBar(callBack: () {
            Navigator.pop(context);
            widget.callBack();
          }),
        ],
      ),
    );
  }

  Widget getMoreNews() {
    List<Widget> list = [];
    for (var news in widget.newsList) {
      list.add(
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => DescriptionNewsPage(
                        news: news,
                        newsList: widget.newsList,
                        callBack: () {
                          setState(() {});
                        },
                      )),
            );
          },
          child: Stack(
            children: [
              Container(
                height: 316,
                width: 250,
                margin: const EdgeInsets.only(bottom: 12, right: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xff250c45)]),
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          news.image!,
                        ))),
              ),
              Container(
                height: 316,
                width: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xff250c45)]),
                ),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      news.title!,
                      style: const TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        news.date!,
                        style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7)),
                      )
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list,
      ),
    );
  }
}
