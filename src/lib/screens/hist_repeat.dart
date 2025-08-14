// import 'package:flutter/material.dart';
// import 'package:prob/provider/add_provider.dart';
// import 'package:provider/provider.dart';

// class HistRepeat extends StatelessWidget {
//   const HistRepeat({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final addProvider = context.read<AddProvider>();
//     final titles = ['없음', '매일', '매주', '매월'];
//     return Scaffold(
//       appBar: AppBar(title: const Text('반복/할부')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             addProvider.isRepeat
//                 ? RepeatList(titles: titles, addProvider: addProvider)
//                 : Installment(addProvider: addProvider),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RepeatList extends StatelessWidget {
//   const RepeatList({
//     super.key,
//     required this.titles,
//     required this.addProvider,
//   });

//   final List<String> titles;
//   final AddProvider addProvider;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: titles.map((title) {
//         return ListTile(
//           title: Text(title),
//           onTap: () {
//             addProvider.setSelectedOption(title);
//             Navigator.of(context).pop();
//           },
//         );
//       }).toList(),
//     );
//   }
// }

// class Installment extends StatelessWidget {
//   const Installment({
//     super.key,
//     required this.addProvider,
//   });

//   final AddProvider addProvider;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: addProvider.installmentController,
//           decoration: InputDecoration(
//             label: const Text("할부 입력(개월 수)"),
//             errorText: addProvider.installmentError,
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('저장'),
//         ),
//       ],
//     );
//   }
// }
