// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:prob/api/consume_hist.dart';
// import 'package:prob/model/categories_model.dart';
// import 'package:prob/model/reqModel/add_consume_hist.dart';
// import 'package:prob/provider/add_provider.dart';
// import 'package:prob/provider/category_provider.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/widgets/common/custom_alert.dart';
// import 'package:provider/provider.dart';

// class AddHistModal {
//   static Future<bool> saveConsumeHist(
//       {required company,
//       required amount,
//       required date,
//       required selectedCategory,
//       required isInstallment,
//       required token,}) async {
//     final addConsumeHist = AddConsumeHist(
//         amount: amount,
//         categoryName: selectedCategory,
//         date: date,
//         receiver: company,
//         installment: isInstallment,);

//     return await ConsumeHistApi.addHist(addConsumeHist, token);
//   }

//   static void addHistModal(BuildContext context, DateTime date) {
//     final addProvider = context.read<AddProvider>();
//     final accessToken = context.read<AuthProvider>().accessToken;
//     final formattedDate = DateFormat('yyyy-MM-dd').format(date);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           contentPadding: const EdgeInsets.all(20.0),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   text: formattedDate,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold, // 굵은 텍스트
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const DropdownMenuWidget(),
//               const SizedBox(height: 10),
//               const AddForm(),
//               const SizedBox(height: 20),
//               // 확인 버튼
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(100, 50),
//                       backgroundColor: Colors.white,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text(
//                       '취소',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(100, 50),
//                       backgroundColor: Colors.blue,
//                     ),
//                     onPressed: () async {
//                       final isValid = addProvider.validateFields();
//                       if (isValid) {
//                         final isSaved = await saveConsumeHist(
//                             token: accessToken,
//                             amount: addProvider.amountController.text,
//                             company: addProvider.companyController.text,
//                             date: formattedDate,
//                             selectedCategory: addProvider.dropdownValue!.name,
//                             isInstallment:
//                                 addProvider.installmentController.text == ''
//                                     ? '0'
//                                     : addProvider.installmentController.text
//                         if (!context.mounted) return;
//                         if (isSaved) {
//                           Navigator.of(context).pop();
//                         } else {
//                           MyAlert.failShow(context, '저장에 실패했어요', null);
//                         }
//                       } else {
//                         MyAlert.failShow(context, '올바르게 입력해주세요', null);
//                       }
//                     },
//                     child: const Text(
//                       '저장',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class DropdownMenuWidget extends StatefulWidget {
//   const DropdownMenuWidget({super.key});

//   @override
//   State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
// }

// class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
//   late List<CategoriesModel> categoryList;
//   late final CategoryProvider categoryProvider;
//   late final AddProvider addProvider;
//   @override
//   void initState() {
//     super.initState();
//     categoryProvider = context.read<CategoryProvider>();
//     addProvider = context.read<AddProvider>();
//     categoryList = categoryProvider.userCategory;

//     addProvider.setDropDownValue(categoryList.first);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<CategoriesModel>(
//       initialSelection: categoryList.first,
//       onSelected: (CategoriesModel? value) =>
//           addProvider.setDropDownValue(value!),
//       dropdownMenuEntries: categoryList
//           .map<DropdownMenuEntry<CategoriesModel>>((CategoriesModel value) {
//         return DropdownMenuEntry<CategoriesModel>(
//             value: value, label: value.name);
//       }).toList(),
//     );
//   }
// }

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
//         // // addProvider.isInstallment
//         // //     ? Row(
//         // //         children: [
//         // //           Expanded(
//         // //             child: TextField(
//         // //               controller: addProvider.installmentController,
//         // //               keyboardType: TextInputType.number,
//         // //               decoration: InputDecoration(
//         // //                 errorText: addProvider.installmentError,
//         // //                 labelText: '할부 개월 수',
//         // //                 hintText: '개월 수를 입력하세요',
//         // //               ),
//         // //               onChanged: (value) {
//         // //                 final months = int.tryParse(value);
//         // //                 if (months != null) {
//         // //                   addProvider.setSelectedInstallment(months);
//         // //                 }
//         // //               },
//         // //             ),
//         // //           ),
//         // //           const SizedBox(width: 8),
//         // //           const Text('개월', style: TextStyle(fontSize: 16)),
//         // //         ],
//         // //       )
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
