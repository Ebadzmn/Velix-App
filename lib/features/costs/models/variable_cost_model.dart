import 'package:flutter/material.dart';

class VariableCostSummaryModel {
  final double totalAmount;
  final int totalTransactions;
  final String currency;
  final String activeFilter;

  VariableCostSummaryModel({
    this.totalAmount = 0.0,
    this.totalTransactions = 0,
    this.currency = 'KR',
    this.activeFilter = 'this_month',
  });

  factory VariableCostSummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VariableCostSummaryModel();
    return VariableCostSummaryModel(
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? 'KR',
      activeFilter: json['active_filter']?.toString() ?? 'this_month',
    );
  }
}

class VariableCostModel {
  final String id;
  final String user;
  final String title;
  final double amount;
  final String category;
  final DateTime? date;
  final String note;
  final String currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VariableCostModel({
    required this.id,
    this.user = '',
    required this.title,
    required this.amount,
    this.category = 'Other',
    this.date,
    this.note = '',
    this.currency = 'KR',
    this.createdAt,
    this.updatedAt,
  });

  factory VariableCostModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      if (d == null) return null;
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    return VariableCostModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? 'Other',
      date: parseDate(json['date']),
      note: json['note']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'KR',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      if (date != null) 'date': '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}',
      'note': note,
      'currency': currency,
    };
  }

  String get formattedAmount {
    final formattedNum = amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(1);
    return '$formattedNum $currency';
  }

  String get formattedDate {
    final targetDate = date ?? createdAt;
    if (targetDate == null) return 'Today';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(targetDate.year, targetDate.month, targetDate.day);

    final difference = today.difference(targetDay).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final m = months[targetDate.month - 1];
    return '${targetDate.day} $m';
  }

  IconData get icon {
    switch (category) {
      case 'Food':
        return Icons.shopping_cart_outlined;
      case 'Takeaway':
        return Icons.local_cafe_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Transport':
        return Icons.directions_bus_outlined;
      case 'The fun':
        return Icons.celebration_outlined;
      case 'Health':
        return Icons.favorite_border_outlined;
      case 'Household':
        return Icons.home_outlined;
      case 'Swish':
        return Icons.swap_horiz_outlined;
      case 'Other':
      default:
        return Icons.credit_card_outlined;
    }
  }

  Color get iconColor {
    switch (category) {
      case 'Food':
        return const Color(0xFF00E676);
      case 'Takeaway':
        return const Color(0xFFFF9800);
      case 'Shopping':
        return const Color(0xFFE040FB);
      case 'Transport':
        return const Color(0xFF00BCD4);
      case 'The fun':
        return const Color(0xFFFF5252);
      case 'Health':
        return const Color(0xFFFF4081);
      case 'Household':
        return const Color(0xFF9482FF);
      case 'Swish':
        return const Color(0xFF448AFF);
      case 'Other':
      default:
        return const Color(0xFF9EA3B0);
    }
  }

  Color get bgColor {
    return iconColor.withValues(alpha: 0.18);
  }
}
