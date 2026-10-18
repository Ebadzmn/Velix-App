import 'package:flutter/material.dart';

class SubscriptionSummaryModel {
  final int totalSubscriptions;
  final double totalPerMonth;
  final double totalPerYear;
  final String currency;

  SubscriptionSummaryModel({
    this.totalSubscriptions = 0,
    this.totalPerMonth = 0.0,
    this.totalPerYear = 0.0,
    this.currency = 'KR',
  });

  factory SubscriptionSummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubscriptionSummaryModel();
    return SubscriptionSummaryModel(
      totalSubscriptions: (json['total_subscriptions'] as num?)?.toInt() ?? 0,
      totalPerMonth: (json['total_per_month'] as num?)?.toDouble() ?? 0.0,
      totalPerYear: (json['total_per_year'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'KR',
    );
  }
}

class SubscriptionItemModel {
  final String id;
  final String user;
  final String name;
  final double price;
  final String billingPeriod; // "monthly" or "yearly"
  final String currency;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionItemModel({
    required this.id,
    this.user = '',
    required this.name,
    required this.price,
    this.billingPeriod = 'monthly',
    this.currency = 'KR',
    this.category = 'Entertainment',
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionItemModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      if (d == null) return null;
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    return SubscriptionItemModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      billingPeriod: json['billing_period']?.toString() ?? 'monthly',
      currency: json['currency']?.toString() ?? 'KR',
      category: json['category']?.toString() ?? 'Entertainment',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'billing_period': billingPeriod,
      'currency': currency,
      'category': category,
    };
  }

  // Formatted price string (e.g. 149 SEK)
  String get formattedPrice {
    final formattedNum = price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(1);
    return '$formattedNum $currency';
  }

  // Formatted date string (e.g. Sep 20)
  String get formattedDate {
    if (createdAt == null) return 'Active';
    try {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final m = months[createdAt!.month - 1];
      return '$m ${createdAt!.day}';
    } catch (_) {
      return 'Active';
    }
  }

  // Annual cost computation
  double get calculatedAnnualCost {
    if (billingPeriod.toLowerCase() == 'yearly') {
      return price;
    }
    return price * 12;
  }

  // Visual Icon & Color helper based on name / category
  IconData get icon {
    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();

    if (lowerName.contains('netflix') || lowerName.contains('movie') || lowerName.contains('cinema') || lowerName.contains('disney') || lowerName.contains('prime') || lowerName.contains('hbo')) {
      return Icons.movie_outlined;
    }
    if (lowerName.contains('spotify') || lowerName.contains('music') || lowerName.contains('sound') || lowerCat.contains('music')) {
      return Icons.music_note_outlined;
    }
    if (lowerName.contains('gym') || lowerName.contains('fitness') || lowerCat.contains('training') || lowerCat.contains('health')) {
      return Icons.fitness_center_outlined;
    }
    if (lowerName.contains('code') || lowerName.contains('cloud') || lowerName.contains('github') || lowerCat.contains('software') || lowerCat.contains('tech')) {
      return Icons.code_rounded;
    }
    if (lowerCat.contains('shopping') || lowerName.contains('amazon') || lowerName.contains('shop')) {
      return Icons.shopping_bag_outlined;
    }
    if (lowerCat.contains('entertainment') || lowerCat.contains('streaming')) {
      return Icons.tv_outlined;
    }
    if (lowerCat.contains('productivity')) {
      return Icons.work_outline;
    }
    return Icons.credit_card_outlined;
  }

  Color get iconColor {
    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();

    if (lowerName.contains('netflix')) return const Color(0xFFE50914);
    if (lowerName.contains('spotify')) return const Color(0xFF1DB954);
    if (lowerName.contains('disney')) return const Color(0xFF0056D2);
    if (lowerName.contains('youtube')) return const Color(0xFFFF0000);
    if (lowerName.contains('apple')) return const Color(0xFFFC3C44);
    if (lowerName.contains('google')) return const Color(0xFF4285F4);
    if (lowerName.contains('amazon') || lowerName.contains('prime')) return const Color(0xFFFF9900);

    if (lowerCat.contains('music')) return const Color(0xFF1DB954);
    if (lowerCat.contains('entertainment') || lowerCat.contains('streaming')) return const Color(0xFFE50914);
    if (lowerCat.contains('training') || lowerCat.contains('health')) return const Color(0xFFFF5252);
    if (lowerCat.contains('software')) return const Color(0xFF9482FF);
    if (lowerCat.contains('shopping')) return const Color(0xFF00BCD4);
    if (lowerCat.contains('productivity')) return const Color(0xFF00E676);

    return const Color(0xFF9482FF);
  }

  Color get bgColor {
    return iconColor.withOpacity(0.18);
  }
}
