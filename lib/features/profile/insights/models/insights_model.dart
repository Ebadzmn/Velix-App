class FinancialHealthData {
  final int score;
  final int maxScore;
  final String status;
  final String description;

  FinancialHealthData({
    this.score = 0,
    this.maxScore = 100,
    this.status = 'Good',
    this.description = '',
  });

  factory FinancialHealthData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FinancialHealthData();
    return FinancialHealthData(
      score: (json['score'] as num?)?.toInt() ?? 0,
      maxScore: (json['max_score'] as num?)?.toInt() ?? 100,
      status: json['status']?.toString() ?? 'Good',
      description: json['description']?.toString() ?? '',
    );
  }
}

class PointsBreakdownCategory {
  final String title;
  final String description;
  final int score;
  final int maxScore;
  final double percentage;

  PointsBreakdownCategory({
    this.title = '',
    this.description = '',
    this.score = 0,
    this.maxScore = 0,
    this.percentage = 0.0,
  });

  factory PointsBreakdownCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PointsBreakdownCategory();
    return PointsBreakdownCategory(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      maxScore: (json['max_score'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class QuickMetricStats {
  final int subscriptionCount;
  final double yearlyCost;
  final String yearlyCostFormatted;
  final double subscriptionIncomePercentage;

  QuickMetricStats({
    this.subscriptionCount = 0,
    this.yearlyCost = 0.0,
    this.yearlyCostFormatted = '0 SEK',
    this.subscriptionIncomePercentage = 0.0,
  });

  factory QuickMetricStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return QuickMetricStats();
    return QuickMetricStats(
      subscriptionCount: (json['subscription_count'] as num?)?.toInt() ?? 0,
      yearlyCost: (json['yearly_subscription_cost'] as num?)?.toDouble() ?? 0.0,
      yearlyCostFormatted: json['yearly_subscription_cost_formatted']?.toString() ?? '0 SEK',
      subscriptionIncomePercentage: (json['subscription_income_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SmartInsightItem {
  final String id;
  final String type;
  final int priority;
  final String title;
  final String message;
  final Map<String, dynamic>? metrics;
  final Map<String, dynamic>? action;

  SmartInsightItem({
    required this.id,
    this.type = 'info',
    this.priority = 1,
    this.title = '',
    this.message = '',
    this.metrics,
    this.action,
  });

  factory SmartInsightItem.fromJson(Map<String, dynamic> json) {
    return SmartInsightItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'info',
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      metrics: json['metrics'] as Map<String, dynamic>?,
      action: json['action'] as Map<String, dynamic>?,
    );
  }
}

class AiCoachData {
  final String action;
  final String screen;
  final String suggestedPrompt;

  AiCoachData({
    this.action = 'chat',
    this.screen = 'ai_coach_screen',
    this.suggestedPrompt = '',
  });

  factory AiCoachData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AiCoachData();
    return AiCoachData(
      action: json['action']?.toString() ?? 'chat',
      screen: json['screen']?.toString() ?? 'ai_coach_screen',
      suggestedPrompt: json['suggested_prompt']?.toString() ?? '',
    );
  }
}
