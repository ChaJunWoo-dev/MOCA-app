class AllCateModel {
  final int subId;
  final String name;
  final String icon;
  final String color;

  AllCateModel({
    required this.subId,
    required this.name,
    required this.icon,
    required this.color,
  });

  // JSON 데이터를 CategoriesModel로 변환하는 팩토리 생성자
  factory AllCateModel.fromJson(Map<String, dynamic> json) {
    return AllCateModel(
      subId: json['sub_id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  // CategoriesModel 객체를 JSON 형식으로 변환
  Map<String, dynamic> toJson() {
    return {
      'sub_id': subId,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }
}
