class AddConsumeHist {
  final String content;
  final String date;
  final String amount;
  final String categoryName;
  final String installment;
  final String card;

  AddConsumeHist({
    required this.content,
    required this.date,
    required this.amount,
    required this.categoryName,
    required this.installment,
    required this.card,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'date': date,
        'amount': amount,
        'category_name': categoryName,
        'is_installment': installment,
        'card': card,
      };
}
