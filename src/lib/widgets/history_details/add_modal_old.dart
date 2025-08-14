// import 'package:flutter/material.dart';
// import 'package:prob/api/category_api.dart';
// import 'package:prob/model/reqModel/add_consume_hist.dart';
// import 'package:prob/provider/add_control_refresh.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/provider/category_provider.dart';
// import 'package:prob/provider/total_provider.dart';
// import 'package:provider/provider.dart';
// import 'history_control_btn.dart';
// import 'package:prob/api/consume_hist.dart';

// class AddModal extends StatefulWidget {
//   const AddModal({super.key});

//   @override
//   State<AddModal> createState() => _AddModalState();
// }

// class _AddModalState extends State<AddModal> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         HistoryControlBtn(
//           label: "추가",
//           method: () => _showCategoryDialog(context),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   void _showCategoryDialog(BuildContext context) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => CategoryModal(
//         onCategorySelected: _showAddDialog,
//       ),
//     );
//   }

//   void saveConsumeHist(company, amount, date, selectedCategoryName, token) {
//     final addConsumeHist = AddConsumeHist(
//       amount: amount,
//       categoryName: selectedCategoryName,
//       date: date,
//       receiver: company,
//     );
//     ConsumeHistApi.addHist(addConsumeHist, token);
//   }

//   void _showAddDialog(BuildContext context) {
//     final token = context.read<AuthProvider>().accessToken;
//     final selectedCate = context.read<CategoryProvider>().selectedCategory;
//     final addControlRefresh =
//         Provider.of<AddControlRefresh>(context, listen: false);

//     final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//     TextEditingController companyController = TextEditingController();
//     TextEditingController amountController = TextEditingController();
//     TextEditingController dateController = TextEditingController();

//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             // Form 위젯으로 감싸기
//             key: formKey, // formKey 연결
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text('상세내용'),
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: companyController,
//                   decoration: const InputDecoration(
//                     labelText: '소비처',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     // 유효성 검사
//                     if (value == null || value.isEmpty) {
//                       return '소비처를 입력해주세요';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: amountController,
//                   decoration: const InputDecoration(
//                     labelText: '금액',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     // 유효성 검사
//                     if (value == null || value.isEmpty) {
//                       return '금액을 입력해주세요';
//                     }
//                     if (double.tryParse(value) == null) {
//                       return '유효한 숫자를 입력해주세요';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 TextFormField(
//                   controller: dateController,
//                   decoration: const InputDecoration(
//                     filled: true,
//                     prefixIcon: Icon(Icons.calendar_today),
//                     labelText: '날짜',
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                   ),
//                   onTap: () async {
//                     DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                     );
//                     if (picked != null) {
//                       dateController.text = picked.toString().split(" ")[0];
//                     }
//                   },
//                   readOnly: true,
//                   validator: (value) {
//                     // 유효성 검사
//                     if (value == null || value.isEmpty) {
//                       return '날짜를 선택해주세요';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text('취소'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         if (formKey.currentState?.validate() ?? false) {
//                           addControlRefresh.change(true);
//                           Provider.of<TotalProvider>(context, listen: false)
//                               .justRefresh();
//                           saveConsumeHist(
//                               companyController.text,
//                               amountController.text,
//                               dateController.text,
//                               selectedCate,
//                               token);

//                           Navigator.pop(context);
//                         }
//                       },
//                       child: const Text('저장'),
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// ---------------------------------------------------------------------
// class CategoryModal extends StatefulWidget {
//   final Function(BuildContext) onCategorySelected;

//   const CategoryModal({super.key, required this.onCategorySelected});

//   @override
//   _CategoryModalState createState() => _CategoryModalState();
// }

// class _CategoryModalState extends State<CategoryModal> {
//   String? _selectedCategory;
//   final TextEditingController _categoryController = TextEditingController();
//   late final CategoryProvider categoryProvider;
//   late Future<List<String>> dbCategories;

//   @override
//   void initState() {
//     categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final token = context.read<AuthProvider>().accessToken;
//     dbCategories = CategoryApi.readCategories(token).then((categories) {
//       updateCategories(categories);

//       return categories;
//     });
//   }

//   void updateCategories(List<String> categories) {
//     Future.microtask(() {
//       categoryProvider.setCategory(categories);
//     });
//   }

//   Future<void> addCategory(String text) async {
//     await CategoryApi.addItem(text, context.read<AuthProvider>().accessToken);

//     setState(() {
//       categoryProvider.addCategory(text);
//     });
//   }

//   Future<void> removeCategory(String? text) async {
//     await CategoryApi.removeItem(
//         text, context.read<AuthProvider>().accessToken);

//     setState(() {
//       categoryProvider.removeCategory(text);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Text('카테고리'),
//             const SizedBox(height: 15),
//             FutureBuilder(
//               future: dbCategories,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (snapshot.hasData) {
//                   final categories = snapshot.data!;

//                   return Column(
//                     children: categories
//                         .map((category) => GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedCategory = category;
//                                   categoryProvider
//                                       .setSelectedCategory(_selectedCategory);
//                                 });
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 2),
//                                 child: Container(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 10),
//                                   color: Colors.transparent,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         category,
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: _selectedCategory == category
//                                               ? Colors.blue
//                                               : Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   );
//                 } else {
//                   return const Text('카테고리를 추가해주세요.');
//                 }
//               },
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => Dialog(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               TextField(
//                                 controller: _categoryController,
//                                 textAlign: TextAlign.center,
//                                 decoration: const InputDecoration(
//                                   labelText: '새 카테고리',
//                                   border: OutlineInputBorder(),
//                                 ),
//                               ),
//                               const SizedBox(height: 15),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('취소'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () async {
//                                       if (_categoryController.text.isNotEmpty) {
//                                         await addCategory(
//                                             _categoryController.text);
//                                         // categoryProvider.addCategory(
//                                         //     _categoryController.text);
//                                         _categoryController.clear();
//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     child: const Text('저장'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text('추가'),
//                 ),
//                 const SizedBox(width: 8),
//                 TextButton(
//                   onPressed: () async {
//                     await removeCategory(_selectedCategory);
//                   },
//                   child: const Text('삭제'),
//                 ),
//                 const SizedBox(width: 8),
//                 TextButton(
//                   onPressed: _selectedCategory == null
//                       ? null
//                       : () {
//                           Navigator.pop(context);
//                           widget.onCategorySelected(context);
//                         },
//                   child: const Text('다음'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
