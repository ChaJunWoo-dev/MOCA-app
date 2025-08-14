class CategoriesModel {
  final int subId;
  final String name;
  final String icon;
  final String color;
  final bool visible;
  final bool chart;

  CategoriesModel.fromJson(Map<String, dynamic> json)
      : subId = json['sub_id'] as int,
        name = json['name'] as String,
        icon = json['icon'],
        color = json['color'],
        visible = json['visible'],
        chart = json['chart'];

  CategoriesModel({
    required this.subId,
    required this.name,
    required this.icon,
    required this.color,
    required this.visible,
    required this.chart,
  });
}
