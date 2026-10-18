import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/network/api_client.dart';
import 'package:abbe_hossain/core/network/api_endpoints.dart';
import 'package:abbe_hossain/core/services/storage_service.dart';
import 'package:abbe_hossain/features/costs/models/variable_cost_model.dart';
import 'package:abbe_hossain/features/subscription/models/subscription_model.dart';
import 'package:abbe_hossain/features/budget/models/budget_model.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final selectedIndex = 0.obs;

  final userCurrency = 'KR'.obs;

  final userName = 'DF'.obs;
  final streakCount = 1.obs;
  final healthScore = 0.obs;
  final healthStatus = 'Good'.obs;
  final healthDescription = ''.obs;
  final leftThisMonth = 0.obs;
  final daysLeft = 2.obs;

  final monthlySubscriptionTotal = 0.obs;
  final nextDrawName = 'None'.obs;
  final nextDrawPrice = '0 KR'.obs;
  final nextDrawIndex = 0.obs;
  Timer? _nextDrawTimer;

  final safeToSpendToday = 0.obs;
  final fixedCostsTotal = '0 KR/month'.obs;

  final savingsGoalTitle = 'Holiday'.obs;
  final savedAmountText = '0 KR of 0 KR'.obs;
  final savingsPercentageText = '0 %'.obs;

  final isPerYear = false.obs;
  final isLoadingSubscriptions = false.obs;
  final subscriptionSummary = SubscriptionSummaryModel().obs;

  final isLoadingCosts = false.obs;
  final costsSummary = VariableCostSummaryModel().obs;
  final selectedCostsFilter = 'This month'.obs;
  final costsFilters = ['This month', 'Last month', 'Last 3 months', 'All'];

  final isLoadingBudget = false.obs;
  final isBudgetOverspent = false.obs;
  final budgetDashboard = Rxn<BudgetDashboardModel>();
  final budgetIncome = 0.obs;
  final budgetFixedExpenses = 0.obs;
  final budgetSubscription = 0.obs;
  final budgetMonthlySavings = 0.obs;
  final budgetMoneyLeft = 0.obs;
  final budgetOverspentAmount = 0.obs;

  final userFullName = 'DF DR'.obs;
  final userProfileImage = ''.obs;
  final userEmail = ''.obs;
  final userBadge = 'Early Adopter 🏆'.obs;
  final unlockedAchievements = '2 of 7 unlocked'.obs;
  final unlockedAchievementEmojis = '🎯 💎'.obs;
  final unlockedCount = 2.obs;
  final totalAchievementsCount = 7.obs;
  final unreadNotificationsCount = 0.obs;

  final RxList<SubscriptionItemModel> subscriptions = <SubscriptionItemModel>[].obs;
  final RxList<VariableCostModel> variableCosts = <VariableCostModel>[].obs;
  final RxList<CostCategoryBreakdownModel> fixedCosts = <CostCategoryBreakdownModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    fetchHomeDashboard();
    fetchSubscriptionDashboard();
    fetchVariableCostsDashboard();
    fetchBudgetDashboard();
    fetchAchievementsSummary();
    fetchUnreadNotificationsCount();
  }

  void _loadUserInfo() {
    try {
      if (Get.isRegistered<StorageService>()) {
        final storage = Get.find<StorageService>();
        userCurrency.value = storage.getUserCurrency();
        final user = storage.getUser();
        if (user != null) {
          final first = user['firstName'] ?? '';
          final last = user['lastName'] ?? '';
          if (first.isNotEmpty || last.isNotEmpty) {
            userName.value = '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}'.toUpperCase();
            userFullName.value = '$first $last'.trim();
          }
          userEmail.value = user['email'] ?? '';
          userProfileImage.value = user['profileImage']?.toString() ?? '';
        }
      }
    } catch (_) {}
  }

  void toggleSubscriptionPeriod(bool val) {
    isPerYear.value = val;
  }

  void selectCostsFilter(String filter) {
    selectedCostsFilter.value = filter;
    fetchVariableCostsDashboard(filterKey: filter);
  }

  String _mapFilterToApi(String filter) {
    switch (filter) {
      case 'Last month':
        return 'last_month';
      case 'Last 3 months':
        return 'last_3_months';
      case 'All':
        return 'all';
      case 'This month':
      default:
        return 'this_month';
    }
  }

  Future<void> fetchSubscriptionDashboard() async {
    isLoadingSubscriptions.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.subscriptionsDashboard);
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          if (data['summary'] != null) {
            subscriptionSummary.value = SubscriptionSummaryModel.fromJson(data['summary']);
            monthlySubscriptionTotal.value = subscriptionSummary.value.totalPerMonth.toInt();
            budgetSubscription.value = subscriptionSummary.value.totalPerMonth.toInt();
          }
          if (data['subscriptions'] != null && data['subscriptions'] is List) {
            final list = (data['subscriptions'] as List)
                .map((item) => SubscriptionItemModel.fromJson(item))
                .toList();
            subscriptions.value = list;
            nextDrawIndex.value = 0;
            _updateNextDrawValues();
            _startNextDrawTimer();
          }
        }
      }
    } catch (e) {
      // In case of network error, fallback gracefully
    } finally {
      isLoadingSubscriptions.value = false;
    }
  }

  Future<void> fetchVariableCostsDashboard({String? filterKey}) async {
    isLoadingCosts.value = true;
    try {
      final apiFilter = _mapFilterToApi(filterKey ?? selectedCostsFilter.value);
      final response = await _apiClient.get(
        ApiEndpoints.variableCostsDashboard,
        queryParameters: {'filter': apiFilter},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          if (data['summary'] != null) {
            costsSummary.value = VariableCostSummaryModel.fromJson(data['summary']);
          }
          if (data['transactions'] != null && data['transactions'] is List) {
            final list = (data['transactions'] as List)
                .map((item) => VariableCostModel.fromJson(item))
                .toList();
            variableCosts.value = list;
          }
        }
      }
    } catch (e) {
      // Network error fallback
    } finally {
      isLoadingCosts.value = false;
    }
  }

  Future<void> deleteVariableCost(String costId) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.variableCosts}/$costId');
      if (response.statusCode == 200 || response.statusCode == 204) {
        variableCosts.removeWhere((item) => item.id == costId);
        fetchVariableCostsDashboard();
        Get.snackbar(
          'Cost Deleted',
          'Variable cost has been removed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF9482FF),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete cost.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  int get totalVariableCostsAmount {
    if (costsSummary.value.totalAmount > 0) {
      return costsSummary.value.totalAmount.toInt();
    }
    int sum = 0;
    for (var cost in variableCosts) {
      sum += cost.amount.toInt();
    }
    return sum;
  }

  Future<void> fetchBudgetDashboard({String? month}) async {
    isLoadingBudget.value = true;
    try {
      final Map<String, dynamic> queryParams = {};
      if (month != null && month.isNotEmpty) {
        queryParams['month'] = month;
      }

      final response = await _apiClient.get(
        ApiEndpoints.budgetDashboard,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          final model = BudgetDashboardModel.fromJson(data);
          budgetDashboard.value = model;

          // Sync summary observables
          final summary = model.summary;
          budgetIncome.value = summary.income.toInt();
          budgetFixedExpenses.value = summary.fixedExpenses.toInt();
          fixedCostsTotal.value = '${summary.fixedExpenses.toInt()} ${summary.currency}/month';
          budgetSubscription.value = summary.subscriptions.toInt();
          budgetMonthlySavings.value = summary.monthlySavings.toInt();
          budgetMoneyLeft.value = summary.moneyLeft.toInt();
          leftThisMonth.value = summary.moneyLeft.toInt();
          safeToSpendToday.value = summary.safeToSpendToday.toInt();
          daysLeft.value = summary.daysLeft;
          budgetOverspentAmount.value = summary.overspentAmount.toInt();
          isBudgetOverspent.value = summary.isOverspent;

          // Sync fixed costs breakdown
          fixedCosts.value = model.breakdown.fixedCosts;

          // Sync savings goal observables
          final goal = model.savingsGoal;
          final curr = summary.currency.isNotEmpty ? summary.currency : userCurrency.value;
          if (goal.title.isNotEmpty) {
            savingsGoalTitle.value = goal.title;
          }
          if (goal.targetAmount > 0) {
            savedAmountText.value = '${goal.savedAmount.toInt()} $curr of ${goal.targetAmount.toInt()} $curr';
            savingsPercentageText.value = '${goal.progressPercentage.toStringAsFixed(0)} %';
          }
        }
      }
    } catch (e) {
      // Graceful fallback for network errors or unconfigured financial profile
    } finally {
      isLoadingBudget.value = false;
    }
  }

  Future<void> fetchHomeDashboard() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.homeDashboard);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          // 1. Economic health score
          if (data['economic_health_score'] != null) {
            healthScore.value = (data['economic_health_score'] as num).toInt();
          } else if (data['economic_health'] != null && data['economic_health']['score'] != null) {
            healthScore.value = (data['economic_health']['score'] as num).toInt();
          }

          // 2. Health status and description
          if (data['economic_health'] != null && data['economic_health'] is Map) {
            final eh = data['economic_health'] as Map;
            if (eh['status'] != null) healthStatus.value = eh['status'].toString();
            if (eh['description'] != null) healthDescription.value = eh['description'].toString();
          }

          // 3. Amount left & safe to spend today
          if (data['amount_left_this_month'] != null) {
            leftThisMonth.value = (data['amount_left_this_month'] as num).toInt();
          }
          if (data['safe_to_spend_today'] != null) {
            safeToSpendToday.value = (data['safe_to_spend_today'] as num).toInt();
          }
          if (data['days_left'] != null) {
            daysLeft.value = (data['days_left'] as num).toInt();
          }

          // 4. Streak count
          if (data['streak_days'] != null) {
            streakCount.value = (data['streak_days'] as num).toInt();
          }
          return;
        }
      }
    } catch (_) {
      // Fallback: If homeDashboard is not configured on backend yet, try dedicated financialHealth endpoint
      try {
        final healthResponse = await _apiClient.get(ApiEndpoints.financialHealth);
        if (healthResponse.statusCode == 200 && healthResponse.data != null) {
          final hData = healthResponse.data['data'];
          if (hData != null && hData is Map<String, dynamic>) {
            if (hData['financial_health_score'] != null) {
              healthScore.value = (hData['financial_health_score'] as num).toInt();
            }
            if (hData['streak_days'] != null) {
              streakCount.value = (hData['streak_days'] as num).toInt();
            }
          }
        }
      } catch (_) {}
    }
  }

  void _startNextDrawTimer() {
    _nextDrawTimer?.cancel();
    if (subscriptions.length > 1) {
      _nextDrawTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (subscriptions.isEmpty) return;
        nextDrawIndex.value = (nextDrawIndex.value + 1) % subscriptions.length;
        _updateNextDrawValues();
      });
    }
  }

  void _updateNextDrawValues() {
    if (subscriptions.isEmpty) {
      nextDrawName.value = 'None';
      nextDrawPrice.value = '0 ${userCurrency.value}';
      return;
    }
    final index = nextDrawIndex.value % subscriptions.length;
    final item = subscriptions[index];
    nextDrawName.value = item.name;
    nextDrawPrice.value = item.formattedPrice;
  }

  @override
  void onClose() {
    _nextDrawTimer?.cancel();
    super.onClose();
  }

  void evaluateLocalAchievements() {
    int count = 1; // first_step is always unlocked
    final emojis = <String>['🎯'];

    // 1. savings_goal_set
    final goal = budgetDashboard.value?.savingsGoal;
    if (goal != null && (goal.title.isNotEmpty || goal.targetAmount > 0)) {
      count++;
      emojis.add('💎');
    } else {
      // Default initial goal badge
      count++;
      emojis.add('💎');
    }

    // 2. subscription_hunter (>= 5 active subscriptions)
    if (subscriptions.length >= 5) {
      count++;
      emojis.add('🔍');
    }

    // 3. budget_master (financial health >= 80)
    if (healthScore.value >= 80) {
      count++;
      emojis.add('🏆');
    }

    // 4. financial_health_90 (financial health >= 90)
    if (healthScore.value >= 90) {
      count++;
      emojis.add('⭐');
    }

    // 5. streak_30_days (streak >= 30)
    if (streakCount.value >= 30) {
      count++;
      emojis.add('🔥');
    }

    // 6. savings_hero (>= 50% savings goal)
    if (goal != null && goal.progressPercentage >= 50 && goal.targetAmount > 0) {
      count++;
      emojis.add('💰');
    }

    unlockedCount.value = count;
    totalAchievementsCount.value = 7;
    unlockedAchievements.value = '$count of 7 unlocked';
    unlockedAchievementEmojis.value = emojis.take(4).join(' ');
  }

  Future<void> fetchAchievementsSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.achievements);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          final summary = data['summary'] as Map<String, dynamic>?;
          final unlockedList = data['unlocked'] as List?;
          final lockedList = data['locked'] as List?;

          int uCount = (summary?['unlocked_count'] as num?)?.toInt() ?? (unlockedList?.length ?? 0);
          int tCount = (summary?['total_achievements'] as num?)?.toInt() ?? ((unlockedList?.length ?? 0) + (lockedList?.length ?? 0));
          if (tCount == 0) tCount = 7;

          final emojisList = <String>[];
          if (unlockedList != null && unlockedList.isNotEmpty) {
            for (var item in unlockedList) {
              if (item is Map && item['emoji'] != null) {
                emojisList.add(item['emoji'].toString());
              }
            }
          }

          if (uCount > 0) {
            unlockedCount.value = uCount;
            totalAchievementsCount.value = tCount;
            unlockedAchievements.value = '$uCount of $tCount unlocked';
            if (emojisList.isNotEmpty) {
              unlockedAchievementEmojis.value = emojisList.take(4).join(' ');
            }
            return;
          }
        }
      }
    } catch (_) {}

    evaluateLocalAchievements();
  }

  Future<void> fetchUnreadNotificationsCount() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.notifications, queryParameters: {'limit': 1});
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final meta = response.data['meta'];
        if (meta != null && meta['unreadCount'] != null) {
          unreadNotificationsCount.value = (meta['unreadCount'] as num).toInt();
        }
      }
    } catch (_) {}
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      fetchBudgetDashboard();
      fetchUnreadNotificationsCount();
    } else if (index == 1) {
      fetchSubscriptionDashboard();
    } else if (index == 2) {
      fetchVariableCostsDashboard();
    } else if (index == 3) {
      fetchBudgetDashboard();
      fetchAchievementsSummary();
    }
  }
}
