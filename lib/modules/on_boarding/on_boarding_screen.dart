// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, avoid_print

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:top_shop/models/components.dart';
import 'package:top_shop/modules/login/login_screen.dart';
import 'package:top_shop/network/local/cache_helper.dart';

class BoardingModel {
  final String image;
  final String lottie;

  BoardingModel({
    required this.image,
    required this.lottie,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardingController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/shop_logo.png',
      lottie: 'assets/lotties/shop1.json',
    ),
    BoardingModel(
      image: 'assets/images/shop_logo.png',
      lottie: 'assets/lotties/shop2.json',
    ),
    BoardingModel(
      image: 'assets/images/shop_logo.png',
      lottie: 'assets/lotties/shop3.json',
    ),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value!) {
        navigateAndFinish(
          LoginScreen(),
          context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text('Skip', style: TextStyle(fontSize: 25)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardingController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    print('last');
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    print('not last');
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, item) =>
                    buildBoardingItem(boarding[item]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardingController,
                  effect: SwapEffect(
                      activeDotColor: defaultColor,
                      dotColor: Colors.orange,
                      type: SwapType.yRotation),
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardingController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Column buildBoardingItem(BoardingModel model) {
    return Column(
      children: [
        Expanded(
          child: Image(
            image: AssetImage('${model.image}'),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Expanded(
          child: Lottie.asset('${model.lottie}'),
        ),
      ],
    );
  }
}
