import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:prob/constants/message_constants.dart';

class ExpenseFormValidator {
  static ({int? amount, String? error}) validateExpenseForm({
    required String amountText,
    required String vendorText,
  }) {
    final digits = toNumericString(amountText.trim());
    final amount = int.tryParse(digits) ?? 0;

    if (amount <= 0) {
      return (amount: null, error: Messages.amountRequired);
    }

    if (vendorText.trim().isEmpty) {
      return (amount: null, error: Messages.vendorRequired);
    }

    return (amount: amount, error: null);
  }
}
