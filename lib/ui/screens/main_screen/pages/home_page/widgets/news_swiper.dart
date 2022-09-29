import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:moderno/data/models/news.dart';

class NewsSwiper extends StatefulWidget {
  final List<News> news;
  const NewsSwiper({super.key, required this.news});

  @override
  State<NewsSwiper> createState() => _NewsSwiperState();
}

class _NewsSwiperState extends State<NewsSwiper> {
  var _currentNewsIndex = 0;
  late final StreamSubscription _scrollClock;
  final PageController _newsController = PageController(viewportFraction: 0.7);

  var _autoSwiped = false;

  @override
  void initState() {
    _scrollClock = Stream.periodic(
      const Duration(seconds: 5),
    ).listen(
      (_) {
        _autoSwiped = true;
        _newsController.animateToPage(
          (_currentNewsIndex + 1) % widget.news.length,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 500),
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollClock.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: _newsController,
            onPageChanged: (index) => setState(
              () {
                if (_autoSwiped) {
                  _autoSwiped = false;
                } else {
                  _scrollClock
                      .pause(Future.delayed(const Duration(seconds: 30)));
                }
                _currentNewsIndex = index;
              },
            ),
            children: widget.news
                .mapIndexed(
                  (index, news) => Center(
                    child: SizedBox(
                      height: 170,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        scale: _currentNewsIndex == index ? 1 : 0.8,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(100, 0, 0, 0),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Image.asset(
                                  news.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      colors: [
                                        Color.fromARGB(255, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0),
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    news.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(
          height: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.news
                .mapIndexed(
                  (index, _) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _currentNewsIndex ? 15 : 10,
                    height: index == _currentNewsIndex ? 15 : 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: index == _currentNewsIndex
                          ? Colors.black26
                          : Colors.black54,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
