import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prob/db/database.dart';
import 'package:prob/providers/category/category_provider.dart';
import 'package:prob/screens/add_expense_screen.dart';
import 'package:prob/utils/icon_mapper.dart';
import 'package:prob/utils/money_format.dart';

class ExpenseTile extends ConsumerWidget {
  final Expense expense;

  const ExpenseTile({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync =
        ref.watch(categoryBySlugProvider(expense.categorySlug ?? ''));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddExpenseScreen(
              initialExpense: expense,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
                  child: categoryAsync.when(
                    loading: () => const SizedBox(width: 20, height: 20),
                    error: (_, __) => const SizedBox(width: 20, height: 20),
                    data: (category) => category == null
                        ? const SizedBox(width: 20, height: 20)
                        : FaIcon(getCategoryIcon(category.icon),
                            color: Colors.blue.shade300, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense.vendor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 17)),
                    Text(
                      expense.memo ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '-${money(expense.amount)}원',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
