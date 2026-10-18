class BudgetDashboardModel {
  final BudgetSummaryModel summary;
  final SavingsGoalModel savingsGoal;
  final BudgetBreakdownModel breakdown;

  BudgetDashboardModel({
    required this.summary,
    required this.savingsGoal,
    required this.breakdown,
  });

  factory BudgetDashboardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BudgetDashboardModel(
        summary: BudgetSummaryModel(),
        savingsGoal: SavingsGoalModel(),
        breakdown: BudgetBreakdownModel(),
      );
    }
    return BudgetDashboardModel(
      summary: BudgetSummaryModel.fromJson(json['summary'] as Map<String, dynamic>?),
      savingsGoal: SavingsGoalModel.fromJson(json['savings_goal'] as Map<String, dynamic>?),
      breakdown: BudgetBreakdownModel.fromJson(json['breakdown'] as Map<String, dynamic>?),
    );
  }
}

class BudgetSummaryModel {
  final double income;
  final double fixedExpenses;
  final double subscriptions;
  final double variableCosts;
  final double monthlySavings;
  final double totalExpenses;
  final double moneyLeft;
  final double safeToSpendToday;
  final int daysLeft;
  final bool isOverspent;
  final double overspentAmount;
  final String currency;

  BudgetSummaryModel({
    this.income = 0.0,
    this.fixedExpenses = 0.0,
    this.subscriptions = 0.0,
    this.variableCosts = 0.0,
    this.monthlySavings = 0.0,
    this.totalExpenses = 0.0,
    this.moneyLeft = 0.0,
    this.safeToSpendToday = 0.0,
    this.daysLeft = 0,
    this.isOverspent = false,
    this.overspentAmount = 0.0,
    this.currency = 'KR',
  });

  factory BudgetSummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BudgetSummaryModel();
    return BudgetSummaryModel(
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      fixedExpenses: (json['fixed_expenses'] as num?)?.toDouble() ?? 0.0,
      subscriptions: (json['subscriptions'] as num?)?.toDouble() ?? 0.0,
      variableCosts: (json['variable_costs'] as num?)?.toDouble() ?? 0.0,
      monthlySavings: (json['monthly_savings'] as num?)?.toDouble() ?? (json['savings_allocated'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['total_expenses'] as num?)?.toDouble() ?? 0.0,
      moneyLeft: (json['money_left'] as num?)?.toDouble() ?? 0.0,
      safeToSpendToday: (json['safe_to_spend_today'] as num?)?.toDouble() ?? 0.0,
      daysLeft: (json['days_left'] as num?)?.toInt() ?? 0,
      isOverspent: json['is_overspent'] == true,
      overspentAmount: (json['overspent_amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'SEK',
    );
  }
}

class SavingsGoalModel {
  final String title;
  final double targetAmount;
  final double savedAmount;
  final double monthlySavingsTarget;
  final double progressPercentage;

  SavingsGoalModel({
    this.title = 'Savings Goal',
    this.targetAmount = 0.0,
    this.savedAmount = 0.0,
    this.monthlySavingsTarget = 0.0,
    this.progressPercentage = 0.0,
  });

  factory SavingsGoalModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SavingsGoalModel();
    return SavingsGoalModel(
      title: json['title']?.toString() ?? 'Savings Goal',
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (json['saved_amount'] as num?)?.toDouble() ?? 0.0,
      monthlySavingsTarget: (json['monthly_savings_target'] as num?)?.toDouble() ?? 0.0,
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class BudgetBreakdownModel {
  final List<CostCategoryBreakdownModel> fixedCosts;
  final List<CostCategoryBreakdownModel> variableCostsByCategory;

  BudgetBreakdownModel({
    this.fixedCosts = const [],
    this.variableCostsByCategory = const [],
  });

  factory BudgetBreakdownModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BudgetBreakdownModel();
    return BudgetBreakdownModel(
      fixedCosts: (json['fixed_costs'] as List<dynamic>?)
              ?.map((item) => CostCategoryBreakdownModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      variableCostsByCategory: (json['variable_costs_by_category'] as List<dynamic>?)
              ?.map((item) => CostCategoryBreakdownModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CostCategoryBreakdownModel {
  final String category;
  final double amount;

  CostCategoryBreakdownModel({
    required this.category,
    required this.amount,
  });

  factory CostCategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CostCategoryBreakdownModel(
      category: json['category']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
