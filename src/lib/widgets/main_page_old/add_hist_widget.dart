// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:prob/api/consume_hist.dart';
// import 'package:prob/model/reqModel/add_consume_hist.dart';
// import 'package:prob/provider/add_provider.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/widgets/common/custom_alert.dart';
// import 'package:provider/provider.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// class AddHistWidget extends StatelessWidget {
//   const AddHistWidget({required this.date, super.key});
//   final DateTime? date;

//   @override
//   Widget build(BuildContext context) {
//     final addProvider = context.read<AddProvider>();
//     final accessToken = context.read<AuthProvider>().accessToken;
//     final formattedDate =
//         date != null ? DateFormat('yyyy-MM-dd').format(date!) : '';
//     addProvider.dateController.text = formattedDate;
//     return Scaffold(
//       appBar: AppBar(title: const Text('소비 기록하기')),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
//         child: Column(
//           // mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 const Text("날짜"),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: addProvider.dateController,
//                     decoration: InputDecoration(
//                       errorText: addProvider.dateError,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Center(
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton2(
//                       customButton: const Column(
//                         children: [
//                           Icon(
//                             Icons.repeat,
//                             size: 30,
//                             color: Colors.red,
//                           ),
//                           Text(
//                             '반복/할부',
//                             style: TextStyle(fontSize: 10, color: Colors.red),
//                           ),
//                         ],
//                       ),
//                       items: [
//                         ...MenuItems.firstItems.map(
//                           (item) => DropdownMenuItem<MenuItem>(
//                             value: item,
//                             child: MenuItems.buildItem(item),
//                           ),
//                         ),
//                         const DropdownMenuItem<Divider>(
//                             enabled: false, child: SizedBox.shrink()),
//                         ...MenuItems.secondItems.map(
//                           (item) => DropdownMenuItem<MenuItem>(
//                             value: item,
//                             child: MenuItems.buildItem(item),
//                           ),
//                         ),
//                       ],
//                       onChanged: (value) {
//                         MenuItems.onChanged(context, value! as MenuItem);
//                       },
//                       dropdownStyleData: DropdownStyleData(
//                         width: 160,
//                         padding: const EdgeInsets.symmetric(vertical: 6),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: Colors.redAccent,
//                         ),
//                         offset: const Offset(0, 8),
//                       ),
//                       menuItemStyleData: MenuItemStyleData(
//                         customHeights: [
//                           ...List<double>.filled(
//                               MenuItems.firstItems.length, 48),
//                           8,
//                           ...List<double>.filled(
//                               MenuItems.secondItems.length, 48),
//                         ],
//                         padding: const EdgeInsets.only(left: 16, right: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // const DropdownMenuWidget(),
//             // const SizedBox(height: 10),
//             const AddForm(),
//             const SizedBox(height: 20),
//             // 확인 버튼
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(100, 50),
//                     backgroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     '취소',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(100, 50),
//                     backgroundColor: Colors.blue,
//                   ),
//                   onPressed: () async {
//                     final isValid = addProvider.validateFields();
//                     if (isValid) {
//                       final isSaved = await saveConsumeHist(
//                           token: accessToken,
//                           amount: addProvider.amountController.text,
//                           company: addProvider.companyController.text,
//                           date: addProvider.dateController.text,
//                           selectedCategory: addProvider.dropdownValue!.name,
//                           isInstallment: addProvider.selectedInstallment == 0
//                               ? addProvider.installmentController.text
//                               : '0',
//                           detail: addProvider.detailController.text);
//                       if (!context.mounted) return;
//                       if (isSaved) {
//                         Navigator.of(context).pop();
//                       } else {
//                         MyAlert.failShow(context, '저장에 실패했어요', null);
//                       }
//                     } else {
//                       MyAlert.failShow(context, '올바르게 입력해주세요', null);
//                     }
//                   },
//                   child: const Text(
//                     '저장',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Future<bool> saveConsumeHist(
//       {required company,
//       required amount,
//       required date,
//       required selectedCategory,
//       required isInstallment,
//       required token,
//       required detail}) async {
//     final addConsumeHist = AddConsumeHist(
//         amount: amount,
//         categoryName: selectedCategory,
//         date: date,
//         receiver: company,
//         installment: isInstallment,
//         detail: detail);

//     return await ConsumeHistApi.addHist(addConsumeHist, token);
//   }
// }

// class MenuItem {
//   const MenuItem({
//     required this.text,
//   });

//   final String text;
//   // final IconData icon;
// }

// abstract class MenuItems {
//   static const List<MenuItem> firstItems = [repeat, installment];
//   static const List<MenuItem> secondItems = [];

//   static const repeat = MenuItem(text: '반복');
//   static const installment = MenuItem(text: '할부');

//   static Widget buildItem(MenuItem item) {
//     return Row(
//       children: [
//         // Icon(item.icon, color: Colors.white, size: 22),
//         const SizedBox(
//           width: 10,
//         ),
//         Expanded(
//           child: Text(
//             item.text,
//             style: const TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   static void onChanged(BuildContext context, MenuItem item) {
//     switch (item) {
//       case MenuItems.repeat:
//         break;
//       case MenuItems.installment:
//         break;
//     }
//   }
// }
// // class DropdownMenuWidget extends StatefulWidget {
// //   const DropdownMenuWidget({super.key});

// //   @override
// //   State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
// // }

// // class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
// //   late List<CategoriesModel> categoryList;
// //   late final CategoryProvider categoryProvider;
// //   late final AddProvider addProvider;
// //   @override
// //   void initState() {
// //     super.initState();
// //     categoryProvider = context.read<CategoryProvider>();
// //     addProvider = context.read<AddProvider>();
// //     categoryList = categoryProvider.userCategory;

// //     addProvider.setDropDownValue(categoryList.first);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return DropdownMenu<CategoriesModel>(
// //       initialSelection: categoryList.first,
// //       onSelected: (CategoriesModel? value) =>
// //           addProvider.setDropDownValue(value!),
// //       dropdownMenuEntries: categoryList
// //           .map<DropdownMenuEntry<CategoriesModel>>((CategoriesModel value) {
// //         return DropdownMenuEntry<CategoriesModel>(
// //             value: value, label: value.name);
// //       }).toList(),
// //     );
// //   }
// // }

// class AddForm extends StatefulWidget {
//   const AddForm({super.key});

//   @override
//   State<AddForm> createState() => _AddFormState();
// }

// class _AddFormState extends State<AddForm> {
//   @override
//   Widget build(BuildContext context) {
//     final addProvider = context.watch<AddProvider>();

//     void formatAmount(AddProvider addProvider) {
//       String currentText =
//           addProvider.amountController.text.replaceAll(',', '');
//       if (currentText.isNotEmpty) {
//         final formatter = NumberFormat('#,###');
//         String formatted = formatter.format(int.parse(currentText));
//         addProvider.amountController.value = TextEditingValue(
//           text: formatted,
//           selection: TextSelection.collapsed(offset: formatted.length),
//         );
//       }
//     }

//     return Container(
//         child: Column(
//       children: [
//         TextField(
//           controller: addProvider.companyController,
//           decoration: InputDecoration(
//             labelText: '소비처',
//             errorText: addProvider.companyError,
//           ),
//         ),
//         // 금액 입력 필드
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: addProvider.amountController,
//                 decoration: InputDecoration(
//                   labelText: '금액',
//                   errorText: addProvider.amountError,
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   formatAmount(addProvider);
//                 },
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Text('원', style: TextStyle(fontSize: 16)),
//           ],
//         ),
//         // const CheckBoxWidget(),
//         // addProvider.isInstallment
//         //     ? Row(
//         //         children: [
//         //           Expanded(
//         //             child: TextField(
//         //               controller: addProvider.installmentController,
//         //               keyboardType: TextInputType.number,
//         //               decoration: InputDecoration(
//         //                 errorText: addProvider.installmentError,
//         //                 labelText: '할부 개월 수',
//         //                 hintText: '개월 수를 입력하세요',
//         //               ),
//         //               onChanged: (value) {
//         //                 final months = int.tryParse(value);
//         //                 if (months != null) {
//         //                   addProvider.setSelectedInstallment(months);
//         //                 }
//         //               },
//         //             ),
//         //           ),
//         //           const SizedBox(width: 8),
//         //           const Text('개월', style: TextStyle(fontSize: 16)),
//         //         ],
//         //       )
//         //     : const SizedBox.shrink(),
//       ],
//     ));
//   }
// }

// // class CheckBoxWidget extends StatelessWidget {
// //   const CheckBoxWidget({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final addprovider = context.watch<AddProvider>();
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           CheckboxListTile(
// //             title: const Text('할부인가요?'),
// //             value: addprovider.isInstallment,
// //             onChanged: (bool? value) =>
// //                 addprovider.setInstallment(value ?? false),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
