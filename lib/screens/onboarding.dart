import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../constants.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentIndex = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('./assets/location.png')),
      Text('Set your location', style: kOnboardingTextStyle),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('./assets/stores.png')),
      Text(
        'Order food online from nearby stores',
        style: kOnboardingTextStyle,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('./assets/delivery.png')),
      Text(
        'Quick delivery at your doorsteps',
        style: kOnboardingTextStyle,
      ),
    ],
  ),
];

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index) {
                _currentIndex = index;
              },
            ),
          ),
          SizedBox(height: 20),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentIndex.toDouble(),
            decorator: DotsDecorator(
              activeColor: Colors.orange,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],
      ),
    );
  }
}
