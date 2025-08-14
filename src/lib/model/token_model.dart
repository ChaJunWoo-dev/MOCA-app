class AuthModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_type': tokenType
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        tokenType: json['token_type'],
      );
}
