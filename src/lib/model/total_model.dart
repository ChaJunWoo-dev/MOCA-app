class TotalModel {
  final int id;
  final int userId;
  final int dayTotal;
  final int monthTotal;

  TotalModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        dayTotal = json['day_total'],
        monthTotal = json['month_total'];

  TotalModel({
    required this.id,
    required this.userId,
    required this.dayTotal,
    required this.monthTotal,
  });
}
