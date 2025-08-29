class BudgetValidationService {
  static const int _minBudget = 1;
  static const int _maxBudget = 100000000; // 1억

  static BudgetValidationResult validateBudget(String input) {
    final text = input.trim();
    final digits = _toNumericString(text);
    final limit = int.tryParse(digits);

    if (limit == null) {
      return const BudgetValidationResult.invalid('올바른 숫자를 입력해주세요.');
    }

    if (limit < _minBudget) {
      return const BudgetValidationResult.invalid('예산은 1원 이상으로 설정해주세요.');
    }

    if (limit > _maxBudget) {
      return const BudgetValidationResult.invalid('예산은 1억 이하로 설정해주세요.');
    }

    return BudgetValidationResult.valid(limit);
  }

  static String getCurrentYearMonth() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  static String _toNumericString(String input) {
    return input.replaceAll(RegExp(r'[^\d]'), '');
  }
}

class BudgetValidationResult {
  final bool isValid;
  final int? value;
  final String? errorMessage;

  const BudgetValidationResult.valid(this.value)
      : isValid = true,
        errorMessage = null;

  const BudgetValidationResult.invalid(this.errorMessage)
      : isValid = false,
        value = null;
}