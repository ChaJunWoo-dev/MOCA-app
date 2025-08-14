import 'package:flutter/material.dart';
import 'package:prob/provider/filter_option_provider.dart';
import 'package:prob/provider/look_list_provider.dart';
import 'package:provider/provider.dart';

class HistDetailOptionLeft extends StatelessWidget {
  const HistDetailOptionLeft({super.key});

  @override
  Widget build(BuildContext context) {
    final filterOptionsProvider = Provider.of<FilterOptionsProvider>(context);
    final lookListProvider = Provider.of<LookListProvider>(context);

    return Row(
      children: [
        TextButton(
          onPressed: () {
            _showPeriodSelectionDialog(context, filterOptionsProvider);
          },
          child: Text(
            filterOptionsProvider.selectedPeriod,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text(
          "•",
          style: TextStyle(fontSize: 25),
        ),
        TextButton(
          onPressed: lookListProvider.showListView
              ? () {
                  _toggleSortOrder(filterOptionsProvider);
                }
              : null,
          child: Text(
            filterOptionsProvider.selectedSortOrder,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showPeriodSelectionDialog(
      BuildContext context, FilterOptionsProvider filterOptionsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('기간 선택'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                filterOptionsProvider.setSelectedPeriod('1개월');
                Navigator.pop(context);
              },
              child: const Text('1개월'),
            ),
            SimpleDialogOption(
              onPressed: () {
                filterOptionsProvider.setSelectedPeriod('3개월');
                Navigator.pop(context);
              },
              child: const Text('3개월'),
            ),
            SimpleDialogOption(
              onPressed: () {
                filterOptionsProvider.setSelectedPeriod('올해');
                Navigator.pop(context);
              },
              child: const Text('올해'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSortOrder(FilterOptionsProvider filterOptionsProvider) {
    if (filterOptionsProvider.selectedSortOrder == "최신순") {
      filterOptionsProvider.setSelectedSortOrder("오래된순");
    } else {
      filterOptionsProvider.setSelectedSortOrder("최신순");
    }
  }
}

class HistDetailOptionRight extends StatelessWidget {
  const HistDetailOptionRight({super.key});

  @override
  Widget build(BuildContext context) {
    final lookListProvider = Provider.of<LookListProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.calendar_month_rounded),
          onPressed: () {
            lookListProvider.setView(false);
          },
        ),
        const VerticalDivider(
          width: 1.0,
          thickness: 1.0,
          color: Colors.grey,
          indent: 8.0, // 위쪽 여백
          endIndent: 8.0, // 아래쪽 여백
        ),
        IconButton(
          icon: const Icon(Icons.list_outlined),
          onPressed: () {
            lookListProvider.setView(true);
          },
        ),
      ],
    );
  }
}
