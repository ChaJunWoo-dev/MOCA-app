class HistModel {
  final int id;
  final String receiver;
  final String date;
  final int amount;
  final int installment;
  final String? card;
  final int subId;
  final int icon;
  final String categoryName;
  final String color;
  final int chart;
  final int visible;

  HistModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        receiver = json['receiver'],
        date = json['date'],
        amount = json['amount'],
        installment = json['installment'],
        card = (json['card']),
        subId = json['sub_id'],
        icon = json['icon'],
        categoryName = json['name'],
        color = json['color'],
        chart = json['chart'],
        visible = json['visible'];

  HistModel({
    required this.id,
    required this.receiver,
    required this.date,
    required this.amount,
    required this.installment,
    this.card,
    required this.subId,
    required this.icon,
    required this.categoryName,
    required this.color,
    required this.chart,
    required this.visible,
  });
}
