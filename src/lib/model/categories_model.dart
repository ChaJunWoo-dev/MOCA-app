class CategoriesModel {
  final int subId; //CategoryIcon id
  final String name;
  final String icon;
  final String color;
  final bool visible;
  final bool chart;

  CategoriesModel(
      {required this.subId,
      required this.name,
      required this.icon,
      required this.color,
      required this.visible,
      required this.chart});

  // 사용자 정보를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => {
        'sub_id': subId,
        'name': name,
        'icon': icon,
        'color': color,
        'visible': visible,
        'chart': chart,
      };

  // JSON을 사용자 객체로 변환하는 메서드
  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
          subId: json['sub_id'] as int,
          name: json['name'] as String,
          icon: json['icon'],
          color: json['color'],
          visible: json['visible'],
          chart: json['chart']);
}
