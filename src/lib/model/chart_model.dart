class ChartModel {
  final int id;
  final String name;
  final int totalAmount;
  final int icon;
  final bool isFavorite;

  ChartModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.totalAmount,
    required this.isFavorite,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
        id: json['id'] as int,
        icon: json['icon'] as int,
        name: json['name'] as String,
        totalAmount: json['total_amount'] as int,
        isFavorite: json['is_favorite'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'category_icon_id': name,
      'total_amount': totalAmount,
    };
  }
}
