// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:prob/api/consume_hist.dart';
// import 'package:prob/model/hist_model.dart';
// import 'package:prob/provider/add_control_refresh.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/provider/filter_option_provider.dart';
// import 'package:prob/provider/look_list_provider.dart';
// import 'package:prob/provider/period_provider.dart';
// import 'package:prob/provider/total_provider.dart';
// import 'package:prob/widgets/history_details/hist_detail_option.dart';
// import 'package:provider/provider.dart';
// import 'package:prob/widgets/history_details/select_date.dart';
// import 'package:intl/intl.dart';

// class HistoryDetails extends StatefulWidget {
//   const HistoryDetails({super.key});

//   @override
//   State<HistoryDetails> createState() => HistoryDetailsState();
// }

// class HistoryDetailsState extends State<HistoryDetails> {
//   //late final Stream<List<HistModel>> histStream;
//   late final StreamController<List<HistModel>> histStreamController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeStream();
//     Future.delayed(Duration.zero, () {
//       // WidgetsBinding.instance.addPostFrameCallback((_) {
//       final token = context.read<AuthProvider>().accessToken;
//       var periodProvider = Provider.of<Periodprovider>(context, listen: false);
//       _fetchInitialData(periodProvider, token);
//     });
//   }

//   void _initializeStream() {
//     histStreamController = StreamController<List<HistModel>>.broadcast();
//   }

//   Future<void> _fetchInitialData(periodProvider, token) async {
//     getHist(periodProvider.startDate, periodProvider.endDate, token);
//   }

//   void getHist(startDate, endDate, token) async {
//     try {
//       final data = await ConsumeHistApi.getHist(token, startDate, endDate);

//       // histStreamController.add(data);
//     } catch (error) {
//       histStreamController.addError(error);
//     }
//   }

//   @override
//   void dispose() {
//     histStreamController.close();
//     super.dispose();
//   }

//   void refresh() {
//     print("refreshing");
//     final periodProvider = Provider.of<Periodprovider>(context, listen: false);
//     final token = context.read<AuthProvider>().accessToken;
//     getHist(periodProvider.startDate, periodProvider.endDate, token);
//     setState(() {
//       Provider.of<TotalProvider>(context, listen: false).justRefresh();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isList = Provider.of<LookListProvider>(context).showListView;

//     return Column(
//       children: [
//         Container(
//           height: 65,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: const BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 color: Colors.black38,
//               ),
//             ),
//             color: Colors.black12,
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               HistDetailOptionLeft(),
//               HistDetailOptionRight(),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: isList
//               ? Consumer<FilterOptionsProvider>(
//                   builder: (context, filterOptionsProvider, child) {
//                     return Consumer<AddControlRefresh>(
//                       builder: (context, addControlRefresh, child) {
//                         if (addControlRefresh.isAdded == true) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             refresh();
//                             addControlRefresh.change(false);
//                           });
//                         }
//                         return ListViewWidget(
//                           histStream: histStreamController.stream,
//                           sortOrder: filterOptionsProvider.selectedSortOrder,
//                           onRefresh: refresh,
//                         );
//                       },
//                     );
//                   },
//                 )
//               : const Text(""),
//         ),
//       ],
//     );
//   }
// }

// class ListViewWidget extends StatelessWidget {
//   const ListViewWidget({
//     super.key,
//     required this.histStream,
//     required this.sortOrder,
//     required this.onRefresh,
//   });

//   final Stream<List<HistModel>> histStream;
//   final String sortOrder;
//   final VoidCallback onRefresh;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SelectDate(),
//             //Icon(Icons.calendar_today_rounded),
//           ],
//         ),
//         const Divider(),
//         DataGroupedHistWidget(
//           histStream: histStream,
//           sortOrder: sortOrder,
//           onRefresh: onRefresh,
//         ),
//       ],
//     );
//   }
// }

// class DataGroupedHistWidget extends StatefulWidget {
//   const DataGroupedHistWidget({
//     super.key,
//     required this.histStream,
//     required this.sortOrder,
//     required this.onRefresh,
//   });

//   final Stream<List<HistModel>> histStream;
//   final String sortOrder;
//   final VoidCallback onRefresh;

//   @override
//   State<DataGroupedHistWidget> createState() => _DataGroupedHistWidgetState();
// }

// class _DataGroupedHistWidgetState extends State<DataGroupedHistWidget> {
//   final Map<String, bool> _expandedStates = {};

//   void removeHist(histId) async {
//     final token = context.read<AuthProvider>().accessToken;
//     await ConsumeHistApi.removeHistOne(histId, token);
//     widget.onRefresh;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<HistModel>>(
//       stream: widget.histStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.data!.isEmpty) {
//           return const Center(
//               child: Text('소비 내역이 없어요!\n추가 버튼을 눌러 내역을 추가해주세요.'));
//         } else if (snapshot.hasData) {
//           var groupedData = groupByMonth(snapshot.data!);

//           var sortedKeys = groupedData.keys.toList();
//           sortedKeys.sort((a, b) {
//             DateTime dateA = DateFormat('yyyy-MM').parse(a);
//             DateTime dateB = DateFormat('yyyy-MM').parse(b);

//             if (widget.sortOrder == "최신순") {
//               return dateB.compareTo(dateA);
//             } else {
//               return dateA.compareTo(dateB);
//             }
//           });

//           final sortedData = <String, List<HistModel>>{};
//           for (var key in sortedKeys) {
//             sortedData[key] = groupedData[key]!;
//           }

//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: sortedData.keys.length,
//             itemBuilder: (context, index) {
//               var month = sortedData.keys.elementAt(index);
//               var items = sortedData[month]!;

//               _expandedStates.putIfAbsent(month, () => true);

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           month,
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             _expandedStates[month]!
//                                 ? Icons.keyboard_arrow_up_rounded
//                                 : Icons.keyboard_arrow_down_rounded,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _expandedStates[month] = !_expandedStates[month]!;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   AnimatedCrossFade(
//                     firstChild: Column(
//                       children: items
//                           .map((hist) => Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           hist.date,
//                                           style: const TextStyle(
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         IconButton(
//                                             onPressed: () =>
//                                                 removeHist(hist.id),
//                                             icon: Icon(
//                                               Icons.cancel,
//                                               color:
//                                                   Colors.black.withOpacity(1.0),
//                                             ))
//                                       ],
//                                     ),
//                                     const SizedBox(height: 4.0),
//                                     Text(
//                                       hist.receiver,
//                                       style: TextStyle(
//                                         fontSize: 14.0,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4.0),
//                                     Text(
//                                       '출금${hist.amount}원',
//                                       style: const TextStyle(
//                                         fontSize: 14.0,
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const Divider(),
//                                   ],
//                                 ),
//                               ))
//                           .toList(),
//                     ),
//                     secondChild: Container(),
//                     crossFadeState: _expandedStates[month]!
//                         ? CrossFadeState.showFirst
//                         : CrossFadeState.showSecond,
//                     duration: const Duration(milliseconds: 300),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           return const Center(child: Text('No data'));
//         }
//       },
//     );
//   }

//   Map<String, List<HistModel>> groupByMonth(List<HistModel> data) {
//     final Map<String, List<HistModel>> groupedData = {};

//     for (var item in data) {
//       final date = DateTime.parse(item.date);
//       final monthYear = DateFormat('yyyy-MM').format(date);

//       if (!groupedData.containsKey(monthYear)) {
//         groupedData[monthYear] = [];
//       }

//       groupedData[monthYear]!.add(item);
//     }

//     return groupedData;
//   }
// }
