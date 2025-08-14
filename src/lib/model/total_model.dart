class TotalModel {
  final int id;
  final int userId;
  final int dayTotal;
  final int monthTotal;

  TotalModel({
    required this.id,
    required this.userId,
    required this.dayTotal,
    required this.monthTotal,
  });

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'day_total': dayTotal,
        'month_total': monthTotal,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory TotalModel.fromJson(Map<String, dynamic> json) => TotalModel(
        id: json['id'],
        userId: json['user_id'],
        dayTotal: json['day_total'],
        monthTotal: json['month_total'],
      );
}
