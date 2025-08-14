import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:prob/model/chart_model.dart';
import 'package:prob/provider/barchart/chart_provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/widgets/common/line_widget.dart';
import 'package:prob/widgets/history_details/bar_icon_changer.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<double> barValue = [];
  int allOutcome = 0;
  final pieTextstyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

  final List<Color> colors = [
    Colors.amber,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.deepOrange,
    Colors.purple,
    Colors.red,
    Colors.yellow,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartProvider, AuthProvider>(
      builder: (context, chartProvider, authProvider, child) {
        final token = authProvider.accessToken;

        //카테고리별 소비 총액
        if (chartProvider.categoryConsume == null ||
            authProvider.accessToken == null ||
            chartProvider.filteredList == null ||
            chartProvider.mappedList == null ||
            chartProvider.total == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 바 차트 데이터 초기화
        _initializeBarValues(chartProvider.mappedList!);

        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      " 한 달 소비 통계",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => chartProvider.setShowPieChart(true),
                    icon: const Icon(Icons.pie_chart_rounded),
                  ),
                  const LineWidget(
                    color: Colors.black,
                    height: 20,
                    width: 1,
                  ),
                  IconButton(
                    onPressed: () => chartProvider.setShowPieChart(false),
                    icon: const Icon(Icons.bar_chart_rounded),
                  )
                ],
              ),
              const SizedBox(height: 10),
              //***************************chart***************************//
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 35, left: 10, right: 10),
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: chartProvider.showPieChart
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              chartProvider.showDetail
                                  ? const SizedBox.shrink()
                                  : Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child:
                                            chartProvider.filteredList!.isEmpty
                                                ? const Center(
                                                    child:
                                                        Text('소비 기록을 추가해보세요!'),
                                                  )
                                                : PieChart(
                                                    PieChartData(
                                                      centerSpaceRadius: 0,
                                                      startDegreeOffset:
                                                          27.5 + 45,
                                                      // sectionsSpace: 4,
                                                      pieTouchData:
                                                          PieTouchData(
                                                        enabled: true,
                                                        touchCallback:
                                                            (FlTouchEvent e,
                                                                PieTouchResponse?
                                                                    r) {
                                                          if (r != null &&
                                                              r.touchedSection !=
                                                                  null) {
                                                            chartProvider
                                                                .setTouchedIndex(r
                                                                    .touchedSection!
                                                                    .touchedSectionIndex);
                                                          }
                                                        },
                                                        mouseCursorResolver:
                                                            (FlTouchEvent e,
                                                                PieTouchResponse?
                                                                    r) {
                                                          if (r != null &&
                                                              r.touchedSection !=
                                                                  null &&
                                                              r.touchedSection!
                                                                      .touchedSectionIndex !=
                                                                  -1) {
                                                            return SystemMouseCursors
                                                                .click;
                                                          }
                                                          return SystemMouseCursors
                                                              .basic;
                                                        },
                                                      ),
                                                      sections: chartProvider
                                                          .filteredList!
                                                          .asMap()
                                                          .entries
                                                          .map(
                                                        (mapEntry) {
                                                          final index =
                                                              mapEntry.key;
                                                          final data =
                                                              mapEntry.value;
                                                          final isTouched =
                                                              chartProvider
                                                                      .touchedIndex ==
                                                                  index;
                                                          final isLast =
                                                              isTouched;
                                                          return PieChartSectionData(
                                                            value: data
                                                                .totalAmount
                                                                .toDouble(),
                                                            color: colors[index %
                                                                colors.length],
                                                            radius: isTouched
                                                                ? 120
                                                                : 110,
                                                            showTitle: true,
                                                            titleStyle: isLast
                                                                ? pieTextstyle
                                                                    .copyWith(
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : pieTextstyle,
                                                            title:
                                                                '${(data.totalAmount / chartProvider.total! * 100).toInt()}%',
                                                            titlePositionPercentageOffset:
                                                                0.5,
                                                            // borderSide: isLast
                                                            //     ? const BorderSide(
                                                            //         width: 4,
                                                            //         color: Colors.black,
                                                            //       )
                                                            //     : null,

                                                            badgeWidget:
                                                                chartProvider
                                                                        .showDetail
                                                                    ? null
                                                                    : _Badge(
                                                                        badgeIcon:
                                                                            Icon(
                                                                          IconData(
                                                                              data.icon,
                                                                              fontFamily: 'MaterialIcons'),
                                                                          color:
                                                                              colors[index % colors.length],
                                                                        ),
                                                                        size:
                                                                            50,
                                                                        borderColor:
                                                                            colors[index %
                                                                                colors.length],
                                                                      ),
                                                            badgePositionPercentageOffset:
                                                                0.98,
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                    swapAnimationDuration:
                                                        const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                  ),
                                      ),
                                    ),
                              chartProvider.filteredList!.isEmpty
                                  ? const SizedBox.shrink()
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: chartProvider.showDetail
                                              ? const Icon(Icons.close)
                                              : const Icon(Icons.list),
                                          onPressed: () =>
                                              chartProvider.toggleShowDetail(),
                                        ),
                                        if (chartProvider.showDetail)
                                          SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: chartProvider
                                                  .filteredList!
                                                  .asMap()
                                                  .entries
                                                  .map((mapEntry) {
                                                final index = mapEntry.key;
                                                final data = mapEntry.value;
                                                MoneyFormatter amountFm =
                                                    MoneyFormatter(
                                                        amount: data.totalAmount
                                                            .toDouble());
                                                MoneyFormatterOutput
                                                    totalAmount =
                                                    amountFm.output;
                                                return FlIndicator(
                                                  color: colors[
                                                      index % colors.length],
                                                  text:
                                                      '${data.name} : ${totalAmount.withoutFractionDigits}원',
                                                  icon: data.icon,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                            ],
                          )
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: _getBarGroups(),
                              titlesData: _buildTitlesData(
                                  chartProvider.mappedList!,
                                  chartProvider.categoryConsume!,
                                  token),
                              barTouchData: BarTouchData(
                                enabled: true,
                                handleBuiltInTouches: false,
                                touchCallback:
                                    (FlTouchEvent e, BarTouchResponse? r) {
                                  if (r != null && r.spot != null) {
                                    int clickedIndex =
                                        r.spot!.touchedBarGroupIndex;

                                    if (e is FlTapDownEvent) {
                                      if (chartProvider.touchedIndex ==
                                          clickedIndex) {
                                        chartProvider.setTouchedIndex(null);
                                      } else {
                                        chartProvider
                                            .setTouchedIndex(clickedIndex);
                                      }
                                    }

                                    // if (e is FlLongPressEnd ||
                                    //     e is FlPanEndEvent ||
                                    //     e is FlTapUpEvent) {
                                    //   // 터치가 끝났을 때
                                    //   if (chartProvider.touchedIndex ==
                                    //       clickedIndex) {
                                    //     // 같은 항목을 다시 클릭하면 선택 해제
                                    //     chartProvider.setTouchedIndex(null);
                                    //   } else {
                                    //     // 새로운 항목이 클릭되면 해당 인덱스 설정
                                    //     chartProvider
                                    //         .setTouchedIndex(clickedIndex);
                                    //   }
                                    // } else if (e is FlLongPressStart ||
                                    //     e is FlPanStartEvent ||
                                    //     e is FlTapDownEvent) {
                                    //   // 터치 시작할 때
                                    //   chartProvider
                                    //       .setTouchedIndex(clickedIndex);
                                    // }
                                  }
                                },
                                touchTooltipData: BarTouchTooltipData(
                                  maxContentWidth: 80,
                                  getTooltipColor: (group) => Colors.black,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    if (rod.toY == 0 ||
                                        groupIndex !=
                                            chartProvider.touchedIndex) {
                                      return null; // 터치된 인덱스가 아니면 툴팁을 표시하지 않음
                                    }
                                    String category = chartProvider
                                        .mappedList![groupIndex].name;
                                    double amount = rod.toY;

                                    MoneyFormatter amountFm2 =
                                        MoneyFormatter(amount: amount);
                                    MoneyFormatterOutput amount2 =
                                        amountFm2.output;
                                    return BarTooltipItem(
                                      '$category\n${amount2.withoutFractionDigits} 원',
                                      const TextStyle(color: Colors.white),
                                    );

                                    // return BarTooltipItem(
                                    //   '$category\n   ${(amount / 10000).toStringAsFixed(2)} 만원',
                                    //   const TextStyle(color: Colors.white),
                                    // );
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                              minY: 0,
                              maxY: barValue.isEmpty ||
                                      barValue.every((val) => val == 0)
                                  ? 1000000
                                  : barValue.reduce((a, b) => a > b ? a : b),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initializeBarValues(List<ChartModel> mappedList) {
    barValue = mappedList.map((data) => data.totalAmount.toDouble()).toList();
    if (barValue.isEmpty) {
      barValue = List.filled(mappedList.length, 0.0);
    }
    allOutcome = barValue.fold(0, (sum, item) => sum + item.toInt());
  }

  List<BarChartGroupData> _getBarGroups() {
    final chartProvider = context.read<ChartProvider>();
    return List.generate(barValue.length, (groupIndex) {
      return BarChartGroupData(
        x: groupIndex,
        barRods: [
          BarChartRodData(
            toY: barValue[groupIndex],
            width: 30,
            color: const Color.fromARGB(255, 253, 180, 167),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            backDrawRodData: BackgroundBarChartRodData(
              show: false,
              toY: 100,
              color: Colors.white,
            ),
          ),
        ],
        showingTooltipIndicators:
            chartProvider.touchedIndex == groupIndex ? [0] : [],
      );
    });
  }

  FlTitlesData _buildTitlesData(List<ChartModel> mappedList,
      List<ChartModel> totalForChart, String? token) {
    double maxValue =
        barValue.isNotEmpty ? barValue.reduce((a, b) => a > b ? a : b) : 0;
    return FlTitlesData(
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() == 3) {
              return Text(
                maxValue > 10000 ? '단위:만원' : '단위:원',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      // 하단 아이콘
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            double iconSize = 30.0;
            Color iconColor = const Color(0xffFFDDCC);
            int index = value.toInt();
            ChartModel? element =
                index < mappedList.length ? mappedList[index] : null;
            IconButton icon = IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                IconData((element!.icon), fontFamily: 'MaterialIcons'),
                size: iconSize,
              ),
              onPressed: () {
                WoltModalSheet.show<void>(
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    final textTheme = Theme.of(context).textTheme;
                    return [
                      BarIconChanger(
                        isLightTheme: true,
                        token: token,
                      ).page1(modalSheetContext, textTheme),
                      BarIconChanger(
                        isLightTheme: true,
                        token: token,
                      ).page2(modalSheetContext, textTheme),
                    ];
                  },
                  modalTypeBuilder: (context) {
                    final size = MediaQuery.sizeOf(context).width;
                    const double pageBreakpoint = 768.0;
                    if (size < pageBreakpoint) {
                      return const WoltBottomSheetType();
                    } else {
                      return const WoltDialogType();
                    }
                  },
                  onModalDismissedWithBarrierTap: () {
                    debugPrint('Closed modal sheet with barrier tap');
                  },
                );
              },
              color: iconColor,
            );

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 5,
              child: icon,
            );
          },
        ),
      ),
      // 좌측 value
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50, // 차지할 너비
          interval: maxValue > 0 ? (maxValue / 4).ceil().toDouble() : 500000,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(fontWeight: FontWeight.w400, fontSize: 14);
            Widget text;

            if (maxValue == 0) {
              switch (value.toInt()) {
                case 50000:
                  text = const Text('5', style: style);
                  break;
                case 500000:
                  text = const Text('50', style: style);
                  break;
                case 1000000:
                  text = const Text('100', style: style);
                  break;
                default:
                  text = const Text('0', style: style);
                  break;
              }
            } else {
              if (maxValue <= 10000) {
                // maxValue가 작을 경우, 소수점 단위로 표시
                if (value == (maxValue * 0.25).toInt()) {
                  text =
                      Text((maxValue * 0.25).toStringAsFixed(0), style: style);
                } else if (value == (maxValue * 0.5).toInt()) {
                  text =
                      Text((maxValue * 0.5).toStringAsFixed(0), style: style);
                } else if (value == (maxValue * 0.75).toInt()) {
                  text =
                      Text((maxValue * 0.75).toStringAsFixed(0), style: style);
                } else if (value == maxValue.toInt()) {
                  text = Text(maxValue.toString(), style: style);
                } else {
                  text = const Text('0', style: style);
                }
              } else {
                // maxValue가 클 경우, 만 단위로 라운드
                if (value == (maxValue * 0.25).toInt()) {
                  text = Text(((maxValue * 0.25 / 10000).toStringAsFixed(1)),
                      style: style);
                } else if (value == (maxValue * 0.5).toInt()) {
                  text = Text(((maxValue * 0.5 / 10000).toStringAsFixed(1)),
                      style: style);
                } else if (value == (maxValue * 0.75).toInt()) {
                  text = Text(((maxValue * 0.75 / 10000).toStringAsFixed(1)),
                      style: style);
                } else if (value == maxValue.toInt()) {
                  text = Text(((maxValue / 10000).toStringAsFixed(1)),
                      style: style);
                } else {
                  text = const Text('0', style: style);
                }
              }
            }

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 0,
              child: text,
            );
          },
        ),
      ),
    );
  }
}

class FlIndicator extends StatelessWidget {
  const FlIndicator({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
  });
  final Color color;
  final String text;
  final int icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          IconData(icon, fontFamily: 'MaterialIcons'),
          color: color,
        ),
        Text(
          text, style: const TextStyle(),
          overflow: TextOverflow.ellipsis, // ... 처리
          maxLines: 1,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.badgeIcon,
    required this.size,
    required this.borderColor,
  });
  final Icon badgeIcon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: badgeIcon),
    );
  }
}
