import 'package:flutter/material.dart';
import 'package:prob/utils/money_format.dart';
import 'package:prob/widgets/common/button.dart';

class AccountSummaryHeader extends StatelessWidget {
  final int budget;

  const AccountSummaryHeader({
    super.key,
    this.budget = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 62,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('지출',
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                  SizedBox(width: 10),
                  Text('152,000원',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('예산',
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(width: 10),
                  Text(
                    '${money(budget)} 원',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF93),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AppButton(
          height: 40,
          textSize: 14,
          text: '분석',
          onPressed: () {},
          elevation: 0,
          backgroundColor: Colors.grey.shade300,
          textColor: Colors.black,
        ),
      ],
    );
  }
}
