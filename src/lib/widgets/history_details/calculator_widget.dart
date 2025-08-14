import 'package:flutter/material.dart';
import 'package:prob/api/total_consume_api.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/period_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

const double _bottomPaddingForButton = 150.0;
const double _buttonHeight = 56.0;
const double _pagePadding = 16.0;
const double _pageBreakpoint = 768.0;

class CalculatorWidget extends StatelessWidget {
  final bool isLightTheme;

  const CalculatorWidget({
    super.key,
    required this.isLightTheme,
  });

  @override
  Widget build(BuildContext context) {
    final periodProvider = context.read<Periodprovider>();
    final token = context.read<AuthProvider>().accessToken;
    final startDate = periodProvider.startDate;
    final endDate = periodProvider.endDate;
    return ElevatedButton(
      onPressed: () async {
        final total =
            await TotalConsumeApi.readPreiodTotal(startDate, endDate, token);
        if (!context.mounted) return;
        if (total == false) {
          MyAlert.failShow(context, '기간 조회에 실패했어요', null);
        } else {
          WoltModalSheet.show<void>(
            context: context,
            pageListBuilder: (modalSheetContext) {
              final textTheme = Theme.of(context).textTheme;
              return [
                page1(modalSheetContext, textTheme, total, startDate, endDate),
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
        }
      },
      child: SizedBox(
        height: _buttonHeight,
        width: MediaQuery.of(context).size.width / 3,
        child: const Center(child: Text('기간 계산기')),
      ),
    );
  }
}

SliverWoltModalSheetPage page1(BuildContext modalSheetContext,
    TextTheme textTheme, int periodTotal, String startDate, String endDate) {
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
              child: Center(child: Text('닫기')),
            ),
          ),
        ],
      ),
    ),
    topBarTitle: Text('$startDate~$endDate', style: textTheme.titleSmall),
    isTopBarLayerAlwaysVisible: true,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        _pagePadding,
        _pagePadding,
        _pagePadding,
        _bottomPaddingForButton,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('$periodTotal')],
        ),
      ),
    ),
  );
}
