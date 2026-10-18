class SavingsGoalItemModel {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final String currency;
  final DateTime? targetDate;
  final bool isActive;
  final DateTime? createdAt;

  SavingsGoalItemModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.savedAmount = 0.0,
    this.currency = 'KR',
    this.targetDate,
    this.isActive = true,
    this.createdAt,
  });

  factory SavingsGoalItemModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      if (d == null) return null;
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    return SavingsGoalItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (json['saved_amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'KR',
      targetDate: parseDate(json['target_date']),
      isActive: json['is_active'] ?? true,
      createdAt: parseDate(json['createdAt']),
    );
  }

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    return (savedAmount / targetAmount * 100).clamp(0.0, 100.0);
  }

  String get formattedSavedAndTarget {
    final s = savedAmount % 1 == 0 ? savedAmount.toInt().toString() : savedAmount.toStringAsFixed(1);
    final t = targetAmount % 1 == 0 ? targetAmount.toInt().toString() : targetAmount.toStringAsFixed(1);
    return '$s $currency of $t $currency';
  }
}
