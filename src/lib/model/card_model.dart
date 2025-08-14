class CardModel {
  final int id;
  final int userId;
  final String name;
  final String company;

  CardModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        name = json['name'],
        company = json['company'];

  CardModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.company,
  });
}
