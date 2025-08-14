class CardModel {
  final int id;
  final int userId;
  final String name;
  final String company;

  CardModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.company,
  });

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'company': company,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        company: json['company'],
      );
}
