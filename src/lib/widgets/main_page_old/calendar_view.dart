// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mobkit_calendar/mobkit_calendar.dart';
// import 'package:prob/provider/calendar/consume_provider.dart';
// import 'package:prob/widgets/main_page_old/add_hist_widget.dart';
// import 'package:prob/widgets/main_page_old/detail_popup.dart';
// import 'package:provider/provider.dart';

// class CalendarView extends StatefulWidget {
//   const CalendarView({super.key});

//   @override
//   State<CalendarView> createState() => _CalendarViewState();
// }

// class _CalendarViewState extends State<CalendarView>
//     with TickerProviderStateMixin {
//   MobkitCalendarConfigModel getConfig(
//       MobkitCalendarViewType mobkitCalendarViewType) {
//     return MobkitCalendarConfigModel(
//       disableWeekendsDays: false,
//       locale: "ko",
//       popupEnable: mobkitCalendarViewType == MobkitCalendarViewType.monthly
//           ? true
//           : false,
//       primaryColor: Colors.lightBlue,
//       monthBetweenPadding: 20,
//       disableOffDays: true,
//       cellConfig: CalendarCellConfigModel(
//         disabledStyle: CalendarCellStyle(
//           textStyle:
//               TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
//           color: Colors.transparent,
//         ),
//         enabledStyle: CalendarCellStyle(
//           textStyle: const TextStyle(fontSize: 14, color: Colors.black),
//           border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
//         ),
//         selectedStyle: CalendarCellStyle(
//           color: Colors.orange, //선택 셀 색상
//           textStyle: const TextStyle(fontSize: 14, color: Colors.white),
//           border: Border.all(color: Colors.black, width: 1),
//         ),
//         currentStyle: CalendarCellStyle(
//           textStyle: const TextStyle(color: Colors.lightBlue), //오늘
//         ),
//       ),
//       calendarPopupConfigModel: CalendarPopupConfigModel(
//         popUpBoxDecoration: BoxDecoration(
//           color: Colors.white.withOpacity(1),
//           borderRadius: const BorderRadius.all(Radius.circular(25)),
//         ),
//         verticalPadding: 30,
//         popupSpace: 10,
//         popupHeight: MediaQuery.of(context).size.height * 0.6,
//         popupWidth: MediaQuery.of(context).size.width,
//         viewportFraction: 0.85,
//       ),
//       topBarConfig: CalendarTopBarConfigModel(
//         isVisibleHeaderWidget:
//             mobkitCalendarViewType == MobkitCalendarViewType.monthly ||
//                 mobkitCalendarViewType == MobkitCalendarViewType.agenda,
//         isVisibleTitleWidget: true,
//         isVisibleMonthBar: false,
//         isVisibleYearBar: false,
//         isVisibleWeekDaysBar: true,
//         weekDaysStyle: const TextStyle(fontSize: 14, color: Colors.black),
//       ),
//     );
//   }

// // 외부 라이브러리는 수정이 가능하지만, debug mode를 종료(완전히)하고 재시작해주어야 적용된다.

//   @override
//   Widget build(BuildContext context) {
//     double pageHeight = MediaQuery.of(context).size.height;
//     return SizedBox(
//       height: pageHeight * 0.6,
//       child: Consumer<ConsumeProvider>(
//         builder: (context, consumeProvider, child) {
//           List<MobkitCalendarAppointmentModel> eventList = [];
//           consumeProvider.histModel.forEach((key, value) {
//             for (var hist in value) {
//               Map<String, dynamic> data = {
//                 'amount': hist.amount,
//                 'name': hist.categoryName,
//                 'icon': Icon(IconData(hist.icon, fontFamily: 'MaterialIcons')),
//               };
//               eventList.add(
//                 MobkitCalendarAppointmentModel(
//                   title: hist.receiver,
//                   appointmentStartDate: DateTime.parse(hist.date),
//                   appointmentEndDate: DateTime.parse(hist.date),
//                   isAllDay: true,
//                   color: Colors.redAccent,
//                   // detail: hist.detail, // "Amount: ${hist.amount}",
//                   eventData: data,
//                   recurrenceModel: null,
//                 ),
//               );
//             }
//           });
//           return MobkitCalendarWidget(
//             minDate: DateTime(1800),
//             key: UniqueKey(),
//             config: getConfig(MobkitCalendarViewType.monthly),
//             dateRangeChanged: (datetime) => null,
//             headerWidget: (List<MobkitCalendarAppointmentModel> models,
//                     DateTime datetime) =>
//                 HeaderWidget(
//               datetime: datetime.toLocal().add(const Duration(hours: 9)),
//               models: models,
//             ),
//             titleWidget: (List<MobkitCalendarAppointmentModel> models,
//                     DateTime datetime) =>
//                 TitleWidget(
//               datetime: datetime.toLocal().add(const Duration(hours: 9)),
//               models: models,
//             ),
//             onSelectionChange: (List<MobkitCalendarAppointmentModel> models,
//                     DateTime datetime) =>
//                 null,
//             eventTap: (model) => null,
//             onPopupWidget: (List<MobkitCalendarAppointmentModel> models,
//                     DateTime datetime) =>
//                 OnPopupWidget(
//               datetime: datetime.toLocal().add(const Duration(hours: 9)),
//               models: models,
//             ),
//             onDateChanged: (DateTime datetime) => null,
//             mobkitCalendarController: MobkitCalendarController(
//               viewType: MobkitCalendarViewType.monthly,
//               appointmentList: eventList,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class OnPopupWidget extends StatelessWidget {
//   const OnPopupWidget({
//     super.key,
//     required this.datetime,
//     required this.models,
//   });

//   final DateTime datetime;
//   final List<MobkitCalendarAppointmentModel> models;

//   @override
//   Widget build(BuildContext context) {
//     // const defaultIcon = Icon(Icons.error);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//       child: models.isNotEmpty
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${DateFormat("EEE, MMMM d", "ko").format(
//                           datetime,
//                         )}일",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       AddButton(
//                         date: datetime,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(
//                   thickness: 1,
//                   color: Colors.grey,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: models.length,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (BuildContext context, int index) {
//                       return GestureDetector(
//                         onTap: () {
//                           ConsumePopup.consumeDetail(context, "");
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 0, vertical: 2),
//                           child: Row(children: [
//                             // Container(
//                             //   height: 40,
//                             //   color: models[index].color,
//                             //   width: 3,
//                             // ),
//                             // const SizedBox(
//                             //   width: 12,
//                             // ),
//                             Flexible(
//                               flex: 1,
//                               child: models[index].eventData?['icon'] as Icon,
//                             ),
//                             const SizedBox(
//                               width: 12,
//                             ),
//                             Flexible(
//                               flex: 4,
//                               fit: FlexFit.tight,
//                               child: Text(
//                                 models[index].title ?? "",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                             Flexible(
//                               flex: 3,
//                               fit: FlexFit.tight,
//                               child: Text(
//                                 "${NumberFormat('#,###').format(models[index].eventData?['amount'])} 원",
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 textAlign: TextAlign.end,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${DateFormat("EEE, MMMMd", "ko").format(datetime)}일",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       AddButton(
//                         date: datetime,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(
//                   thickness: 1,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class AddButton extends StatelessWidget {
//   const AddButton({
//     required this.date,
//     super.key,
//   });

//   final DateTime date;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AddHistWidget(date: date),
//           ),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.amber,
//         iconColor: Colors.blue,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       ),
//       child: const Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.add),
//           SizedBox(width: 8),
//           Text("추가"),
//         ],
//       ),
//     );
//   }
// }

// class TitleWidget extends StatelessWidget {
//   const TitleWidget({
//     super.key,
//     required this.datetime,
//     required this.models,
//   });

//   final DateTime datetime;
//   final List<MobkitCalendarAppointmentModel> models;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(children: [
//         Text(
//           DateFormat("yyyy MMMM", "ko").format(datetime),
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ]),
//     );
//   }
// }

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({
//     super.key,
//     required this.datetime,
//     required this.models,
//   });

//   final DateTime datetime;
//   final List<MobkitCalendarAppointmentModel> models;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(children: [
//         Text(
//           DateFormat("MMMM", "ko").format(datetime),
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//             color: Colors.black54,
//           ),
//         ),
//       ]),
//     );
//   }
// }
