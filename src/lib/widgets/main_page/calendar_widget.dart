import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/api/card_api.dart';
import 'package:prob/api/category_api.dart';
import 'package:prob/api/consume_hist.dart';
import 'package:prob/model/hist_model.dart';
import 'package:prob/model/reqModel/add_consume_hist.dart';
import 'package:prob/provider/add_provider.dart';
import 'package:prob/provider/card_provider.dart';
import 'package:prob/provider/category_provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/main_page/calendar_provider.dart';
import 'package:prob/service/auth_service.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:provider/provider.dart';
import 'utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    super.key,
    required this.consumeHist,
    required this.onRefresh,
  });

  final Map<String, List<HistModel>> consumeHist;
  final VoidCallback onRefresh;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final customBorderInside =
      const BorderSide(width: 0.3, color: Color(0xFF707070));
  static const _black = Color(0xFF3B2304);
  static const borderColor = Color(0xFFC19F64);
  static const dividerColor = Color(0xFFE39B3D);
  static const topBorderColor = Color(0xFFE39B3D);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();

    return calendarProvider.selectedDay != null
        ? Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        DateFormat('MM월 dd일,  E', 'ko_KR')
                            .format(calendarProvider.selectedDay!),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B2304)),
                      ),
                    ),
                    const Divider(
                      color: topBorderColor,
                      height: 0,
                    ),
                    SizedBox(
                      height: 400,
                      child: ListViewWidget(
                        dividerColor: dividerColor.withOpacity(0.76),
                        onRefresh: widget.onRefresh,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF9DEB9),
                  ),
                  onPressed: () async {
                    _addAndEditModal(
                        context: context,
                        title: '소비내역 추가',
                        onRefresh: widget.onRefresh,
                        histId: -1);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 26),
                    child: Text(
                      "+ 추가",
                      style: TextStyle(
                        fontSize: 13,
                        color: _black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : TableCalendar(
            locale: 'ko_KR',
            //title, 좌우 버튼
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              headerPadding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                border: Border(
                  top: BorderSide(width: 1, color: borderColor),
                  right: BorderSide(width: 1, color: borderColor),
                  left: BorderSide(width: 1, color: borderColor),
                ),
              ),
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: _black,
                fontSize: 18,
              ),
              titleTextFormatter: (date, locale) {
                return DateFormat.MMMM(locale).format(date);
              },
              leftChevronMargin: const EdgeInsets.only(left: 60),
              rightChevronMargin: const EdgeInsets.only(right: 60),
              leftChevronPadding: const EdgeInsets.all(3),
              rightChevronPadding: const EdgeInsets.all(3),
              leftChevronIcon: const Icon(
                Icons.chevron_left_sharp,
                color: topBorderColor,
                size: 28,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right_outlined,
                color: topBorderColor,
                size: 28,
              ),
            ),
            //요일 높이
            daysOfWeekHeight: 30,
            //셀 높이
            rowHeight: 70,
            startingDayOfWeek: StartingDayOfWeek.monday,

            calendarStyle: CalendarStyle(
              weekNumberTextStyle: const TextStyle(color: _black),
              disabledTextStyle:
                  const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              defaultTextStyle: const TextStyle(
                color: _black,
                fontSize: 13,
              ),
              isTodayHighlighted: true,
              todayTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: topBorderColor,
                fontSize: 14,
              ),
              todayDecoration: const BoxDecoration(color: Colors.transparent),
              selectedDecoration:
                  const BoxDecoration(color: Colors.transparent),
              selectedTextStyle: const TextStyle(color: _black),
              cellAlignment: Alignment.topLeft,
              tableBorder: TableBorder(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
                horizontalInside: customBorderInside,
                verticalInside: customBorderInside,
                bottom: const BorderSide(width: 1, color: borderColor),
                top: const BorderSide(width: 1, color: topBorderColor),
                left: const BorderSide(width: 1, color: borderColor),
                right: const BorderSide(width: 1, color: borderColor),
              ),
            ),
            //날짜 셀 커스텀
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final dayKey = DateFormat('yyyy-MM-dd').format(day);
                final monthKey = DateFormat('yyyy-MM').format(day);
                List<HistModel> dayData =
                    widget.consumeHist[monthKey]?.where((hist) {
                          return hist.date == dayKey;
                        }).toList() ??
                        [];
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          '${day.day}', // 날짜 표시
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    if (dayData.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 3, right: 3),
                          child: Wrap(
                            spacing: 2.0, // 원 간격
                            runSpacing: 2.0, // 줄 간격

                            children: (dayData.length <= 6)
                                ? [
                                    ...dayData.take(6).map((data) {
                                      return Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Color(
                                              int.parse(data.color)), // 색상 변환
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    }),
                                  ]
                                : [
                                    ...dayData.take(4).map((data) {
                                      return Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Color(
                                              int.parse(data.color)), // 색상 변환
                                          shape: BoxShape.circle,
                                        ),
                                      );
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        '+${dayData.length - 4}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black, // 텍스트 색상
                                        ),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: calendarProvider.focusedDay,
            calendarFormat: _calendarFormat,
            //day custom
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 17),
              weekendStyle: TextStyle(fontSize: 17),
            ),
            //날짜 selected
            selectedDayPredicate: (day) {
              return isSameDay(calendarProvider.selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              calendarProvider.selectDay(selectedDay, focusedDay);

              final filteredHistories = widget.consumeHist.entries
                  .where((entry) =>
                      entry.key == DateFormat('yyyy-MM').format(selectedDay))
                  .expand((entry) => entry.value)
                  .where((hist) {
                final historyDate =
                    DateFormat('yyyy-MM-dd').parse(hist.date).toLocal();
                return isSameDay(historyDate, selectedDay);
              }).toList();
              calendarProvider.setSelectHist(filteredHistories);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              calendarProvider.selectDay(null, focusedDay);
            },
          );
  }
}

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({
    required this.dividerColor,
    required this.onRefresh,
    super.key,
  });
  final Color dividerColor;
  final VoidCallback onRefresh;

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final addProvider = context.read<AddProvider>();
    return ListView.separated(
      // shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: calendarProvider.selectHist.length,
      itemBuilder: (context, index) {
        final hist = calendarProvider.selectHist[index];
        return _listRow(hist, addProvider, widget.onRefresh);
      },
      separatorBuilder: (context, index) {
        return Divider(color: widget.dividerColor, thickness: 0.3, height: 0);
      },
    );
  }

  Widget _listRow(
      HistModel hist, AddProvider provider, VoidCallback onRefresh) {
    const textColor = Color(0xFF3B2304);
    String formatNumberWithComma(int number) {
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    }

    return TextButton(
      onPressed: () {
        provider.setEditInfo(
            amount: '${hist.amount}',
            cardName: hist.card,
            categoryName: hist.categoryName,
            installment: '${hist.installment}',
            receiver: hist.receiver);
        _addAndEditModal(
            context: context,
            title: '상세 내역',
            onRefresh: widget.onRefresh,
            histId: hist.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                hist.receiver,
                style: const TextStyle(
                  fontSize: 15,
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${formatNumberWithComma(hist.amount)} 원", // 금액 표시
              style: const TextStyle(
                fontSize: 15,
                color: textColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Color(int.parse(hist.color)),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              width: 38,
              height: 28,
            )
          ],
        ),
      ),
    );
  }
}

void showCustomSnackBar(BuildContext context, String coment) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.04,
      left: MediaQuery.of(context).size.width * 0.35,
      right: MediaQuery.of(context).size.width * 0.35,
      child: Material(
        child: Container(
          // height: 40,
          // width: M,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(234, 95, 66, 27),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            coment,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

void _addAndEditModal(
    {required BuildContext context,
    required String title,
    required VoidCallback onRefresh,
    required histId}) {
  Future<void> saveData(BuildContext context, AddProvider addProvider) async {
    final calendarProvider = context.read<CalendarProvider>();
    final authProvider = context.read<AuthProvider>();
    bool isTokenValid = await authProvider.checkAndRefreshToken();

    if (isTokenValid) {
      final accessToken = authProvider.accessToken;
      try {
        final fields = addProvider.getFieldValues();
        late String date;

        if (context.mounted) {
          date = calendarProvider.selectedDay!.toIso8601String();
        }

        final addConsumeHist = AddConsumeHist(
          amount: fields['amount'],
          categoryName: fields['category'],
          installment:
              fields['installment'] == 'none' ? '0' : fields['installment'],
          content: fields['content'],
          card: fields['card'],
          date: date,
        );

        final saved = await ConsumeHistApi.addHist(addConsumeHist, accessToken);

        calendarProvider.setSelectHist(saved);
        addProvider.resetFields();

        if (context.mounted) {
          showCustomSnackBar(context, '저장 완료');
          Navigator.of(context).pop();
          onRefresh();
        }
      } catch (e) {
        if (context.mounted) {
          MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
        }
      }
    } else {
      if (context.mounted) {
        MyAlert.failShow(context, '다시 로그인 해주세요', null);
      }
    }
  }

  Future<void> editData(
      BuildContext context, AddProvider addProvider, int histId) async {
    final calendarProvider = context.read<CalendarProvider>();
    final authProvider = context.read<AuthProvider>();
    bool isTokenValid = await authProvider.checkAndRefreshToken();

    if (isTokenValid) {
      final accessToken = authProvider.accessToken;
      try {
        final fields = addProvider.getFieldValues();
        late String date;

        if (context.mounted) {
          date = calendarProvider.selectedDay!.toIso8601String();
        }

        final addConsumeHist = AddConsumeHist(
          amount: fields['amount'],
          categoryName: fields['category'],
          installment:
              fields['installment'] == 'none' ? '0' : fields['installment'],
          content: fields['content'],
          card: fields['card'],
          date: date,
        );

        final edited =
            await ConsumeHistApi.editHist(addConsumeHist, accessToken, histId);

        calendarProvider.setSelectHist(edited);
        addProvider.resetFields();

        if (context.mounted) {
          showCustomSnackBar(context, '수정 완료');
          Navigator.of(context).pop();
          onRefresh();
        }
      } catch (e) {
        if (context.mounted) {
          MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
        }
      }
    } else {
      if (context.mounted) {
        MyAlert.failShow(context, '다시 로그인 해주세요', null);
      }
    }
  }

  Future<void> removeData(
      BuildContext context, AddProvider addProvider, int histId) async {
    final calendarProvider = context.read<CalendarProvider>();
    final authProvider = context.read<AuthProvider>();
    bool isTokenValid = await authProvider.checkAndRefreshToken();

    if (isTokenValid) {
      final accessToken = authProvider.accessToken;
      try {
        final removed = await ConsumeHistApi.removeHist(histId, accessToken);
        calendarProvider.setSelectHist(removed);
        if (context.mounted) {
          showCustomSnackBar(context, '삭제 완료');
          Navigator.of(context).pop();
          onRefresh();
        }
      } catch (e) {
        if (context.mounted) {
          MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
        }
      }
    } else {
      if (context.mounted) {
        MyAlert.failShow(context, '다시 로그인 해주세요', null);
      }
    }
  }

  const textStyle = TextStyle(color: Color(0xFF3B2304), fontSize: 17);
  const dividerColor = Color(0xFFE1E1E1);
  final maxWidth = MediaQuery.of(context).size.width - 46;
  final maxHeight = MediaQuery.of(context).size.height / 5 * 3;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final addProvider = context.watch<AddProvider>();
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: maxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 16, left: 16),
                child: Text(title, style: textStyle),
              ),
              const Divider(color: dividerColor, thickness: 1, height: 0),
              Padding(
                padding:
                    const EdgeInsets.only(top: 11.0, right: 29, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '할부',
                          style: textStyle.copyWith(fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    addProvider.installmentSelected == 'self'
                        ? SizedBox(
                            width: 66,
                            // height: 18,
                            child: TextField(
                              controller: addProvider.installmentController,
                              keyboardType: TextInputType.number,
                              cursorColor: const Color(0xFF707070),
                              cursorWidth: 1,
                              decoration: const InputDecoration(
                                isDense: true,

                                contentPadding:
                                    EdgeInsets.only(top: 4, bottom: 4, left: 6),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 136, 81, 10),
                                        width: 1.5)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide:
                                      BorderSide(color: Color(0xFF707070)),
                                ),
                                // isDense: true,
                              ),
                              style: textStyle.copyWith(fontSize: 11),
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (value) {
                                addProvider.setInstallmentSelfInputValue(value);
                              },
                            ),
                          )
                        : SizedBox(
                            width: 66,
                            child: DropdownButtonFormField<String>(
                              value: addProvider.installmentSelected,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.only(top: 1, bottom: 1, left: 6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide:
                                      BorderSide(color: Color(0xFF707070)),
                                ),
                              ),
                              style: textStyle.copyWith(fontSize: 11),
                              items: const [
                                DropdownMenuItem(
                                    value: 'none', child: Text('해당 없음')),
                                DropdownMenuItem(
                                    value: '2', child: Text('2개월')),
                                DropdownMenuItem(
                                    value: '3', child: Text('3개월')),
                                DropdownMenuItem(
                                    value: 'self', child: Text('직접입력')),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  addProvider.setInstallmentSelected(newValue);
                                }
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 13,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const ModalItem(textStyle: textStyle, subTitle: '항목'),
              const ModalItem(textStyle: textStyle, subTitle: '분류'),
              const ModalItem(textStyle: textStyle, subTitle: '카드'),
              const ModalItem(textStyle: textStyle, subTitle: '금액'),
              const Center(
                child: Text(
                  '*할부 선택 시 원 금액을 입력하시면 자동으로 계산됩니다',
                  style: TextStyle(
                      fontSize: 10, color: Color.fromARGB(160, 59, 35, 4)),
                ),
              ),

              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title == '상세 내역'
                        ? ElevatedButton(
                            onPressed: () async {
                              // addProvider.resetFields();
                              await removeData(context, addProvider, histId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE2344D),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 40.0),
                            ),
                            child: const Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              addProvider.resetFields();
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDBCDCF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 40.0),
                            ),
                            child: const Text(
                              '취소',
                              style: TextStyle(
                                color: Color(0xFF4F4F4F),
                                fontSize: 13,
                              ),
                            ),
                          ),
                    ElevatedButton(
                      onPressed: title == '상세 내역'
                          ? () async {
                              final valid = addProvider.validateFields();
                              if (valid) {
                                await editData(context, addProvider, histId);
                              } else {
                                if (addProvider.installmentError != null) {
                                  if (context.mounted) {
                                    MyAlert.failShow(context,
                                        addProvider.installmentError!, null);
                                  }
                                }
                              }
                            }
                          : () async {
                              final valid = addProvider.validateFields();
                              if (valid) {
                                await saveData(context, addProvider);
                              } else {
                                if (addProvider.installmentError != null) {
                                  if (context.mounted) {
                                    MyAlert.failShow(context,
                                        addProvider.installmentError!, null);
                                  }
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: const Color(0xFF5366DF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 40.0),
                      ),
                      child: const Text(
                        '저장',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      );
    },
  );
}

class ModalItem extends StatelessWidget {
  const ModalItem({
    super.key,
    required this.textStyle,
    required this.subTitle,
  });
  final String subTitle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    void fetchData(token) async {
      final categories = await CategoryApi.readCategories(token);
      final cards = await CardApi.readCards(token);
      if (context.mounted) {
        context.read<CategoryProvider>().setCategory(categories);
        context.read<CardProvider>().setCardList(cards);
      }
    }

    void getCategories() async {
      final token = context.read<AuthProvider>().accessToken;
      fetchData(token);
    }

    getCategories();
    List<DropdownMenuItem<String>> getDropdownItems(List<String> options) {
      return options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 27.0 / 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(subTitle, style: textStyle),
        const SizedBox(width: 42),
        Expanded(
          child: subTitle == '분류'
              ? Consumer3<CategoryProvider, AddProvider, CardProvider>(
                  builder: (context, categoryProvider, addProvider,
                      cardProvider, child) {
                    if (categoryProvider.userCategory.isEmpty ||
                        addProvider.categorySelected == '' ||
                        addProvider.categorySelected == 'none') {
                      return const DisableDropDownButton();
                    } else {
                      final categories = categoryProvider.userCategory
                          .map((category) => category.name)
                          .toList();
                      final initialValue =
                          addProvider.categorySelected.isNotEmpty
                              ? addProvider.categorySelected
                              : categories.isNotEmpty
                                  ? categories[0]
                                  : null;
                      return DropdownButtonFormField<String>(
                        value: initialValue, //addProvider.categorySelected,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 136, 81, 10),
                                  width: 1.5)),
                          isDense: true,
                          errorText: addProvider.categoryError,
                          errorStyle: const TextStyle(fontSize: 10),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Color(0xFF707070)),
                          ),
                        ),
                        style: const TextStyle(fontSize: 15),
                        items: getDropdownItems(categories),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            addProvider.setSecondSelectedOption(newValue);
                          }
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        menuMaxHeight: 260,
                      );
                    }
                  },
                )
              : subTitle == '카드'
                  ? Consumer2<AddProvider, CardProvider>(
                      builder: (context, addProvider, cardProvider, child) {
                        if (cardProvider.cardList.isEmpty ||
                            addProvider.cardSelected == 'none') {
                          return const DisableDropDownButton();
                        } else {
                          final cards = cardProvider.cardList
                              .map((category) => category.name)
                              .toList();

                          return DropdownButtonFormField<String>(
                            value: addProvider.cardSelected,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 136, 81, 10),
                                      width: 1.5)),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide:
                                    BorderSide(color: Color(0xFF707070)),
                              ),
                            ),
                            style: const TextStyle(fontSize: 15),
                            items: getDropdownItems(cards),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                addProvider.setSecondSelectedOption(newValue);
                              }
                            },
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            menuMaxHeight: 260,
                          );
                        }
                      },
                    )
                  : Consumer<AddProvider>(
                      builder: (context, addProvider, child) {
                      return TextField(
                        //항목, 금액 컨트롤러
                        controller: subTitle == '항목'
                            ? addProvider.contentController
                            : addProvider.amountController,
                        cursorColor: const Color(0xFF707070),
                        cursorWidth: 1,
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xFF3B2304)),
                        decoration: InputDecoration(
                          errorText: subTitle == '항목'
                              ? addProvider.companyError
                              : addProvider.amountError,
                          errorStyle: const TextStyle(fontSize: 10),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 136, 81, 10),
                                  width: 1.5)),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Color(0xFF707070))),
                        ),
                      );
                    }),
        ),
      ]),
    );
  }
}

class DisableDropDownButton extends StatelessWidget {
  const DisableDropDownButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: 'none',
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFB0B0B0), width: 1.5)),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFB0B0B0)),
        ),
      ),
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFFB0B0B0),
      ),
      items: const [
        DropdownMenuItem(value: 'none', child: Text('없음')),
      ],
      onChanged: null,
      icon: const Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Color(0xFFB0B0B0),
      ),
    );
  }
}
