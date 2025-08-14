class UserModel {
  final int id;
  final String nickname;
  final String image;

  UserModel({required this.id, required this.nickname, required this.image});

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'image': image,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'], nickname: json['nickname'], image: json['image']);
}

// 데이터 형식
// {
//   "email": String,
//   "nickname": String,
//   "id": int,
//   "disabled": bool
// }