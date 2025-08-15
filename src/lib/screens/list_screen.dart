import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  static const preButton = 'assets/images/pre_button.png';
  static const calendarImage = 'assets/images/calendar.png';

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: CalendarHeader(
              preButton: ListScreen.preButton,
              calendarImage: ListScreen.calendarImage),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 23),
        //   child: FutureBuilder<Map<String, List<HistModel>>>(
        //     future: getConsumeHist(token),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       } else if (snapshot.hasError) {
        //         // print(snapshot.error);
        //         return const Center(
        //           child: Text('데이터를 불러오는 동안 오류가 발생했습니다.'),
        //         );
        //       } else if (snapshot.hasData) {
        //         // calendarProvider.refresh(snapshot.data!);
        //         return CalendarWidget(
        //           consumeHist: snapshot.data!,
        //           onRefresh: _refreshData,
        //         );
        //       } else {
        //         return CalendarWidget(
        //           consumeHist: const {},
        //           onRefresh: _refreshData,
        //         );
        //       }
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.preButton,
    required this.calendarImage,
  });

  final String preButton;
  final String calendarImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: SizedBox(
            width: 24,
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: Image.asset(preButton),
            ),
          ),
        ),
        Transform.scale(
          scale: 4,
          child: Transform.rotate(
            angle: 0.2,
            child: Image.asset(
              calendarImage,
              width: 30,
            ),
          ),
        ),
        const SizedBox(width: 24)
      ],
    );
  }
}
