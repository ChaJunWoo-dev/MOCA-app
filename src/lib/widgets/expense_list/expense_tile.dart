import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prob/db/database.dart';
import 'package:prob/utils/icon_mapper.dart';
import 'package:prob/utils/money_format.dart';

class ExpenseTile extends StatelessWidget {
  final Expense item;
  final VoidCallback? onTap;

  const ExpenseTile({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        categoryIconMap[item.categorySlug],
                        color: Colors.blue.shade300,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.vendor,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        item.memo ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '-${money(item.amount)}원',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
