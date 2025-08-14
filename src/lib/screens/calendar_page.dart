import 'package:flutter/material.dart';
import 'package:prob/api/consume_hist.dart';
import 'package:prob/model/hist_model.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/provider/main_page/calendar_provider.dart';
import 'package:prob/widgets/main_page/calendar_widget.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  static const preButton = 'assets/images/pre_button.png';
  static const calendarImage = 'assets/images/calendar.png';

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Future<Map<String, List<HistModel>>> getConsumeHist(token) async {
    final consume = await ConsumeHistApi.getHist(token);
    return consume;
  }

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.read<HomeProvider>();
    final calendarProvider = context.read<CalendarProvider>();
    final token = context.read<AuthProvider>().accessToken;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: CalendarHeader(
              calendarProvider: calendarProvider,
              homeProvider: homeProvider,
              preButton: CalendarPage.preButton,
              calendarImage: CalendarPage.calendarImage),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: FutureBuilder<Map<String, List<HistModel>>>(
            future: getConsumeHist(token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // print(snapshot.error);
                return const Center(
                  child: Text('데이터를 불러오는 동안 오류가 발생했습니다.'),
                );
              } else if (snapshot.hasData) {
                // calendarProvider.refresh(snapshot.data!);
                return CalendarWidget(
                  consumeHist: snapshot.data!,
                  onRefresh: _refreshData,
                );
              } else {
                return CalendarWidget(
                  consumeHist: const {},
                  onRefresh: _refreshData,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.calendarProvider,
    required this.homeProvider,
    required this.preButton,
    required this.calendarImage,
  });

  final CalendarProvider calendarProvider;
  final HomeProvider homeProvider;
  final String preButton;
  final String calendarImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            calendarProvider.selectedDay == null
                ? homeProvider.setHomeWidget('mainPage')
                : calendarProvider.selectDay(null, null);
          },
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
