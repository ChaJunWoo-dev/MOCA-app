import 'package:flutter/material.dart';
import 'package:prob/api/category_api.dart';
import 'package:prob/model/chart_model.dart';
import 'package:prob/provider/barchart/chart_provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _bottomPaddingForButton = 150.0;
const double _buttonHeight = 56.0;
const double _buttonWidth = 200.0;
const double _pagePadding = 16.0;
const double _pageBreakpoint = 768.0;
// final materialColorsInGrid = allMaterialColors.take(20).toList();
// final materialColorsInSliverList = allMaterialColors.sublist(20, 25);

class BarIconChanger extends StatelessWidget {
  final bool isLightTheme;
  final String? token;

  const BarIconChanger({
    super.key,
    required this.isLightTheme,
    required this.token,
  });

  SliverWoltModalSheetPage page1(
      BuildContext modalSheetContext, TextTheme textTheme) {
    return WoltModalSheetPage(
        hasSabGradient: false,
        stickyActionBar: Padding(
          padding: const EdgeInsets.all(_pagePadding),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: Navigator.of(modalSheetContext).pop,
                child: const SizedBox(
                  height: _buttonHeight,
                  width: double.infinity,
                  child: Center(child: Text('취소')),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: WoltModalSheet.of(modalSheetContext).showNext,
                child: const SizedBox(
                  height: _buttonHeight,
                  width: double.infinity,
                  child: Center(child: Text('변경할게요')),
                ),
              ),
            ],
          ),
        ),
        topBarTitle: Text('지금 관심있는 카테고리는', style: textTheme.titleSmall),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _pagePadding,
            _pagePadding,
            _pagePadding,
            _bottomPaddingForButton,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
            child: Consumer<ChartProvider>(
                // Consumer로 상태를 읽음
                builder: (context, chartProvider, child) {
              if (chartProvider.mappedList == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    chartProvider.mappedList!.asMap().entries.map((mapEntry) {
                  final data = mapEntry.value;

                  return Column(
                    children: [
                      Icon(IconData(data.icon, fontFamily: 'MaterialIcons')),
                      Text(
                        data.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }).toList(), // 리스트로 변환
              );
            }),
          ),
        ));
  }

  SliverWoltModalSheetPage page2(
      BuildContext modalSheetContext, TextTheme textTheme) {
    final chartProvider = modalSheetContext.read<ChartProvider>();
    return SliverWoltModalSheetPage(
      pageTitle: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Text(
          '제가 변경할 카테고리는',
          style:
              textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      leadingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: WoltModalSheet.of(modalSheetContext).showPrevious,
      ),
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(_pagePadding),
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Consumer2<ChartProvider, AuthProvider>(
          builder: (context, chartProvider, authProvider, child) {
            return ElevatedButton(
              onPressed: () async {
                if (chartProvider.chartCategories.isNotEmpty &&
                    chartProvider.chartCategories.length == 4) {
                  final isSuccess = await CategoryApi.updateUserCategories(
                      chartProvider.chartCategories, token);
                  if (!modalSheetContext.mounted) return;
                  if (isSuccess) {
                    chartProvider.clearSelections();
                    chartProvider.reFetchData(authProvider.accessToken);
                    Navigator.of(modalSheetContext).pop();
                  } else {
                    MyAlert.failShow(modalSheetContext, '저장에 실패했어요', null);
                  }
                } else {
                  MyAlert.failShow(modalSheetContext, '카테고리 4개를 선택해주세요', null);
                }
              },
              child: const SizedBox(
                height: _buttonHeight,
                width: double.infinity,
                child: Center(child: Text('저장할게요')),
              ),
            );
          },
        ),
      ),
      mainContentSliversBuilder: (context) => [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: _bottomPaddingForButton),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                return CategoryTile(
                  color: Colors.cyanAccent,
                  category: chartProvider.categoryConsume![index],
                );
              },
              childCount: chartProvider.categoryConsume!.length,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        WoltModalSheet.show<void>(
          context: context,
          pageListBuilder: (modalSheetContext) {
            final textTheme = Theme.of(context).textTheme;
            return [
              page1(modalSheetContext, textTheme),
              page2(modalSheetContext, textTheme),
            ];
          },
          modalTypeBuilder: (context) {
            final size = MediaQuery.sizeOf(context).width;
            if (size < _pageBreakpoint) {
              return isLightTheme
                  ? const WoltBottomSheetType()
                  : const WoltBottomSheetType().copyWith(
                      shapeBorder: const BeveledRectangleBorder(),
                    );
            } else {
              return isLightTheme
                  ? const WoltDialogType()
                  : const WoltDialogType().copyWith(
                      shapeBorder: const BeveledRectangleBorder(),
                    );
            }
          },
          onModalDismissedWithBarrierTap: () {
            Navigator.of(context).pop();
          },
        );
      },
      child: const SizedBox(
        height: _buttonHeight,
        width: _buttonWidth,
        child: Center(child: Text('Show Modal Sheet')),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Color color;
  final ChartModel category;

  const CategoryTile({
    super.key,
    required this.color,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final chartProvider = context.watch<ChartProvider>();
    return GestureDetector(
      onTap: () {
        if (!chartProvider.chartCategories.contains(category.id) &&
            chartProvider.chartCategories.length >= 4) {
          MyAlert.successShow(context, '이미 4개를 선택했어요');
          return;
        }
        chartProvider.selectCategory(category.id);
      },
      child: Container(
        color: chartProvider.chartCategories.contains(category.id)
            ? color
            : Colors.white60,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconData(category.icon, fontFamily: 'MaterialIcons')),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// List<Color> get allMaterialColors {
//   List<Color> allMaterialColorsWithShades = [];

//   for (MaterialColor color in Colors.primaries) {
//     allMaterialColorsWithShades.add(color.shade100);
//     allMaterialColorsWithShades.add(color.shade200);
//     allMaterialColorsWithShades.add(color.shade300);
//     allMaterialColorsWithShades.add(color.shade400);
//     allMaterialColorsWithShades.add(color.shade500);
//     allMaterialColorsWithShades.add(color.shade600);
//     allMaterialColorsWithShades.add(color.shade700);
//     allMaterialColorsWithShades.add(color.shade800);
//     allMaterialColorsWithShades.add(color.shade900);
//   }
//   return allMaterialColorsWithShades;
// }
