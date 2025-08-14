class ChartModel {
  final int id;
  final String name;
  final int totalAmount;
  final int icon;
  final bool isFavorite;

  ChartModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        icon = json['icon'] as int,
        name = json['name'] as String,
        totalAmount = json['total_amount'] as int,
        isFavorite = json['is_favorite'] as bool;

  ChartModel({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.icon,
    required this.isFavorite,
  });
}
