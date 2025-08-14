class AllCateoryModel {
  final int subId;
  final String name;
  final String icon;
  final String color;

  AllCateoryModel.fromJson(Map<String, dynamic> json)
      : subId = json['sub_id'],
        name = json['name'],
        icon = json['icon'],
        color = json['color'];

  AllCateoryModel({
    required this.subId,
    required this.name,
    required this.icon,
    required this.color,
  });
}
