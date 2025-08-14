class UserModel {
  final int id;
  final String nickname;
  final String image;

  UserModel({
    required this.id,
    required this.nickname,
    required this.image,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'],
        image = json['image'];
}
