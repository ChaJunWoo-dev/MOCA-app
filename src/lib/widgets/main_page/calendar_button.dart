import 'package:flutter/material.dart';
import 'package:prob/provider/home_provider.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});
  static const cardTextColor = Color(0xFF707070);
  final textStyle = const TextStyle(color: cardTextColor, fontSize: 18);
  static const calendarBg = Color.fromRGBO(224, 162, 121, 0.5);
  static const graphBg = Color.fromRGBO(228, 218, 107, 0.43);
  static const calendarImage = 'assets/images/calendar.png';
  static const graphImage = 'assets/images/graph.png';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buttonWidget(
          context: context,
          image: calendarImage,
          // url: '/home/calendar_month',
          title: '달력',
          text1: "내가 하루에\n쓰는 돈은?",
          text2: "하루 소비\n확인하기",
        ),
        _buttonWidget(
          context: context,
          image: graphImage,
          // url: '/home/chart_month',
          title: '통계',
          text1: "내가 가장 많이\n소비한 곳은?",
          text2: "분야별 소비\n통계 확인하기",
        ),
      ],
    );
  }

  Widget _buttonWidget({
    required BuildContext context,
    // required String url,
    required image,
    required title,
    required text1,
    required text2,
  }) {
    final containerWidth = MediaQuery.of(context).size.width / 2 - 36;
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    final homeProvider = context.read<HomeProvider>();
    return TextButton(
      style: buttonStyle,
      onPressed: () {
        homeProvider.setHomeWidget('calendarPage');
      },
      child: Container(
        width: containerWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(224, 162, 121, 0.5), Colors.white],
            stops: [0.35, 0.35],
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextWidget(
          textStyle: textStyle,
          image: image,
          title: title,
          text1: text1,
          text2: text2,
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.textStyle,
    required this.image,
    required this.title,
    required this.text1,
    required this.text2,
  });

  final TextStyle textStyle;
  final String image;
  final String title;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.translate(
                offset: const Offset(0, -20),
                child: Text(title,
                    style: textStyle.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis),
              ),
              ImageWidget(image: image)
            ],
          ),
          //content
          Text(text1,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 14),
          Text(text2, style: textStyle.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: image == 'assets/images/calendar.png' ? 2.4 : 2.7,
      child: Transform.translate(
        offset: image == 'assets/images/calendar.png'
            ? const Offset(0, 0)
            : const Offset(-2, -4),
        child: Transform.rotate(
          angle: 11 * math.pi / 180,
          child: Image.asset(
            image,
            width: 65,
          ),
        ),
      ),
    );
  }
}
