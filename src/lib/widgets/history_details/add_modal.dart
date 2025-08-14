// import 'package:flutter/material.dart';
// import 'package:prob/api/category_api.dart';
// import 'package:prob/model/categories_model.dart';
// import 'package:prob/model/reqModel/add_consume_hist.dart';
// import 'package:prob/provider/add_provider.dart';
// import 'package:prob/provider/common/auth_provider.dart';
// import 'package:prob/provider/category_provider.dart';
// import 'package:prob/provider/signup/categories_provider.dart';
// import 'package:prob/provider/total_provider.dart';
// import 'package:prob/widgets/common/custom_alert.dart';
// import 'package:provider/provider.dart';
// import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
// import 'package:prob/api/consume_hist.dart';

// const double _bottomPaddingForButton = 130.0;
// const double _buttonHeight = 56.0;
// const double _buttonWidth = 100.0;
// const double _pagePadding = 16.0;
// const double _pageBreakpoint = 768.0;

// class AddModal extends StatelessWidget {
//   final bool isLightTheme;

//   const AddModal({super.key, required this.isLightTheme});

//   SliverWoltModalSheetPage page1(
//       BuildContext modalSheetContext, TextTheme textTheme) {
//     final categoryProvider = modalSheetContext.read<CategoryProvider>();
//     return SliverWoltModalSheetPage(
//       pageTitle: Padding(
//         padding: const EdgeInsets.all(_pagePadding),
//         child: Text(
//           '어떤 카테고리인가요?',
//           style:
//               textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ),
//       leadingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.arrow_back_rounded),
//         onPressed: WoltModalSheet.of(modalSheetContext).showPrevious,
//       ),
//       trailingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.close),
//         onPressed: Navigator.of(modalSheetContext).pop,
//       ),
//       mainContentSliversBuilder: (context) => [
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (_, index) => CategoryTile(
//               color: Colors.amber,
//               category: categoryProvider.userCategory[index],
//             ),
//             childCount: categoryProvider.userCategory.length,
//           ),
//         ),
//       ],
//     );
//   }

//   SliverWoltModalSheetPage page2(
//       BuildContext modalSheetContext, TextTheme textTheme) {
//     return SliverWoltModalSheetPage(
//       pageTitle: Padding(
//         padding: const EdgeInsets.all(_pagePadding),
//         child: Text(
//           '정보를 입력해주세요',
//           style:
//               textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ),
//       leadingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.arrow_back_rounded),
//         onPressed: WoltModalSheet.of(modalSheetContext).showPrevious,
//       ),
//       trailingNavBarWidget: IconButton(
//         padding: const EdgeInsets.all(_pagePadding),
//         icon: const Icon(Icons.close),
//         onPressed: Navigator.of(modalSheetContext).pop,
//       ),
//       stickyActionBar: Padding(
//         padding: const EdgeInsets.all(_pagePadding),
//         child: Consumer3<CategoryProvider, AddFormProvider, AuthProvider>(
//             builder:
//                 (context, categoryProvider, formProvider, authProvider, child) {
//           if (categoryProvider.addSelectCategory == null ||
//               authProvider.accessToken == null) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return ElevatedButton(
//               onPressed: () async {
//                 final isValid = formProvider.validateFields();
//                 if (isValid) {
//                   Provider.of<TotalProvider>(context, listen: false)
//                       .justRefresh();
//                   final isSaved = await saveConsumeHist(
//                       formProvider.companyController.text,
//                       formProvider.amountController.text,
//                       formProvider.dateController.text,
//                       categoryProvider.addSelectCategory!.name,
//                       authProvider.accessToken);
//                   if (isSaved) {
//                     categoryProvider.setSelectCategory(null);
//                     Navigator.pop(context);
//                   } else {
//                     MyAlert.failShow(context, '저장에 실패했어요', null);
//                   }
//                 } else {
//                   MyAlert.failShow(context, '올바르게 입력해주세요', null);
//                 }
//               },
//               child: const SizedBox(
//                 height: _buttonHeight,
//                 width: double.infinity,
//                 child: Center(child: Text('저장할게요')),
//               ),
//             );
//           }
//         }),
//       ),
//       mainContentSliversBuilder: (context) => [
//         const SliverPadding(
//           padding: EdgeInsets.only(bottom: _bottomPaddingForButton),
//           sliver: SliverToBoxAdapter(child: FormTile(color: Colors.black)),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.read<AuthProvider>();
//     return ElevatedButton(
//       onPressed: () async {
//         final categoryProvider = context.read<CategoryProvider>();
//         final userCategoryList =
//             await CategoryApi.readCategories(authProvider.accessToken);
//         categoryProvider.setCategory(userCategoryList);

//         WoltModalSheet.show<void>(
//           context: context,
//           pageListBuilder: (modalSheetContext) {
//             final textTheme = Theme.of(context).textTheme;
//             return [
//               page1(modalSheetContext, textTheme),
//               page2(modalSheetContext, textTheme),
//             ];
//           },
//           modalTypeBuilder: (context) {
//             final size = MediaQuery.sizeOf(context).width;
//             if (size < _pageBreakpoint) {
//               return isLightTheme
//                   ? const WoltBottomSheetType()
//                   : const WoltBottomSheetType().copyWith(
//                       shapeBorder: const BeveledRectangleBorder(),
//                     );
//             } else {
//               return isLightTheme
//                   ? const WoltDialogType()
//                   : const WoltDialogType().copyWith(
//                       shapeBorder: const BeveledRectangleBorder(),
//                     );
//             }
//           },
//           onModalDismissedWithBarrierTap: () {
//             Navigator.of(context).pop();
//           },
//         );
//       },
//       child: const SizedBox(
//         height: _buttonHeight,
//         width: _buttonWidth,
//         child: Center(child: Text('추가')),
//       ),
//     );
//   }
// }

// class CategoryTile extends StatelessWidget {
//   final Color color;
//   final CategoriesModel category;

//   const CategoryTile({
//     super.key,
//     required this.color,
//     required this.category,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = context.read<CategoryProvider>();
//     return TextButton(
//       onPressed: () {
//         categoryProvider.setSelectCategory(category);
//         WoltModalSheet.of(context).showNext();
//       },
//       style: TextButton.styleFrom(
//         // backgroundColor: Colors.cyan.shade600, // 배경색 설정
//         padding: EdgeInsets.zero,
//         minimumSize: Size(MediaQuery.of(context).size.width, 60),
//       ),
//       child: Center(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(IconData(category.icon, fontFamily: 'MaterialIcons')),
//             const SizedBox(width: 8),
//             Text(
//               category.name,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FormTile extends StatelessWidget {
//   final Color color;

//   const FormTile({
//     super.key,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final formProvider = context.watch<AddFormProvider>();
//     final categoryProvider = context.read<CategoryProvider>();
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: _pagePadding),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               children: [
//                 Icon(IconData(categoryProvider.addSelectCategory!.icon,
//                     fontFamily: 'MaterialIcons')),
//                 Text(categoryProvider.addSelectCategory!.name),
//               ],
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: formProvider.companyController,
//               decoration: InputDecoration(
//                 labelText: '소비한 곳은?',
//                 // border: OutlineInputBorder(),
//                 errorText: formProvider.companyError,
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: formProvider.amountController,
//               decoration: InputDecoration(
//                 labelText: '비용은?',
//                 errorText: formProvider.amountError,
//                 // border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: formProvider.dateController,
//               decoration: InputDecoration(
//                 filled: true,
//                 prefixIcon: const Icon(Icons.calendar_today),
//                 labelText: '날짜',
//                 enabledBorder: const OutlineInputBorder(
//                   borderSide: BorderSide.none,
//                 ),
//                 focusedBorder: const OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue),
//                 ),
//                 errorText: formProvider.dateError,
//               ),
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null) {
//                   formProvider.dateController.text =
//                       picked.toString().split(" ")[0];
//                 }
//               },
//               readOnly: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Future<bool> saveConsumeHist(
//     company, amount, date, selectedCategory, token) async {
//   final addConsumeHist = AddConsumeHist(
//     amount: amount,
//     category: selectedCategory,
//     date: date,
//     receiver: company,
//   );
//   return await ConsumeHistApi.addHist(addConsumeHist, token);
// }
