import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../home/controller/home_controller.dart';
import '../models/achievements_model.dart';

class AchievementsController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;

  // Streak observables
  final currentStreak = 1.obs;
  final streakTitle = '1 day streak'.obs;
  final streakMessage = 'Open the app every day to build your streak'.obs;

  // Financial health observable
  final financialHealthPercentage = 0.0.obs;

  // Achievement lists observables
  final unlockedList = <AchievementItem>[].obs;
  final lockedList = <AchievementItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialFallbacks();
      fetchAchievements();
    });
  }

  void _loadInitialFallbacks() {
    int streak = 1;
    double health = 0.0;
    int subCount = 0;
    bool hasSavingsGoal = false;
    double savingsGoalProgress = 0.0;

    // Sync financial health score & user state from HomeController if available
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      streak = homeController.streakCount.value;
      final score = homeController.healthScore.value;
      if (score > 0) {
        financialHealthPercentage.value = score.toDouble();
        health = score.toDouble();
      }
      subCount = homeController.subscriptions.length;
      final goal = homeController.budgetDashboard.value?.savingsGoal;
      if (goal != null && (goal.title.isNotEmpty || goal.targetAmount > 0)) {
        hasSavingsGoal = true;
        savingsGoalProgress = goal.progressPercentage;
      }
    }

    currentStreak.value = streak > 0 ? streak : 1;
    streakTitle.value = '${currentStreak.value} day streak';

    _computeBadges(
      health: health,
      subCount: subCount,
      streak: streak,
      hasSavingsGoal: hasSavingsGoal,
      savingsGoalProgress: savingsGoalProgress,
      serverUnlocked: [],
      serverLocked: [],
    );
  }

  void _computeBadges({
    required double health,
    required int subCount,
    required int streak,
    required bool hasSavingsGoal,
    required double savingsGoalProgress,
    List<AchievementItem> serverUnlocked = const [],
    List<AchievementItem> serverLocked = const [],
  }) {
    // Standard definitions of all 7 badges
    final allBadges = [
      AchievementItem(
        id: 'first_step',
        title: 'First step',
        description: 'Completed onboarding and got started with Koll',
        emoji: '🎯',
        category: 'onboarding',
        isUnlocked: true,
      ),
      AchievementItem(
        id: 'savings_goal_set',
        title: 'Savings goal set',
        description: 'Created your first savings goal',
        emoji: '💎',
        category: 'savings',
        isUnlocked: hasSavingsGoal || true,
      ),
      AchievementItem(
        id: 'subscription_hunter',
        title: 'Subscription hunter',
        description: 'Have 5 or more active subscriptions',
        emoji: '🔍',
        category: 'subscriptions',
        isUnlocked: subCount >= 5,
        progress: AchievementProgress(
          current: subCount.toDouble(),
          target: 5.0,
          percentage: (subCount / 5.0 * 100).clamp(0.0, 100.0),
        ),
      ),
      AchievementItem(
        id: 'budget_master',
        title: 'Budget Master',
        description: 'Achieved financial health of 80 or more',
        emoji: '🏆',
        category: 'health',
        isUnlocked: health >= 80,
        progress: AchievementProgress(
          current: health,
          target: 80.0,
          percentage: (health / 80.0 * 100).clamp(0.0, 100.0),
        ),
      ),
      AchievementItem(
        id: 'financial_health_90',
        title: 'Financial health 90+',
        description: 'Achieved amazing financial health',
        emoji: '⭐',
        category: 'health',
        isUnlocked: health >= 90,
        progress: AchievementProgress(
          current: health,
          target: 90.0,
          percentage: (health / 90.0 * 100).clamp(0.0, 100.0),
        ),
      ),
      AchievementItem(
        id: 'streak_30_days',
        title: '30 day streak',
        description: 'Opened the app 30 days in a row',
        emoji: '🔥',
        category: 'streak',
        isUnlocked: streak >= 30,
        progress: AchievementProgress(
          current: streak.toDouble(),
          target: 30.0,
          percentage: (streak / 30.0 * 100).clamp(0.0, 100.0),
        ),
      ),
      AchievementItem(
        id: 'savings_hero',
        title: 'Savings hero',
        description: 'Reached 50% of a savings goal',
        emoji: '💰',
        category: 'savings',
        isUnlocked: (savingsGoalProgress >= 50 && hasSavingsGoal),
        progress: AchievementProgress(
          current: savingsGoalProgress,
          target: 50.0,
          percentage: (savingsGoalProgress / 50.0 * 100).clamp(0.0, 100.0),
        ),
      ),
    ];

    final serverUnlockedIds = serverUnlocked.map((e) => e.id).toSet();
    final serverLockedMap = {for (var e in serverLocked) e.id: e};
    final serverUnlockedMap = {for (var e in serverUnlocked) e.id: e};

    final newUnlocked = <AchievementItem>[];
    final newLocked = <AchievementItem>[];

    for (var badge in allBadges) {
      if (serverUnlockedIds.contains(badge.id)) {
        newUnlocked.add(serverUnlockedMap[badge.id]!);
      } else if (badge.isUnlocked) {
        newUnlocked.add(badge);
      } else {
        if (serverLockedMap.containsKey(badge.id)) {
          newLocked.add(serverLockedMap[badge.id]!);
        } else {
          newLocked.add(badge);
        }
      }
    }

    for (var sItem in serverUnlocked) {
      if (!allBadges.any((b) => b.id == sItem.id) && !newUnlocked.any((b) => b.id == sItem.id)) {
        newUnlocked.add(sItem);
      }
    }
    for (var sItem in serverLocked) {
      if (!allBadges.any((b) => b.id == sItem.id) && !newLocked.any((b) => b.id == sItem.id) && !newUnlocked.any((b) => b.id == sItem.id)) {
        newLocked.add(sItem);
      }
    }

    unlockedList.value = newUnlocked;
    lockedList.value = newLocked;

    _syncToHomeController();
  }

  void _syncToHomeController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        final uCount = unlockedList.length;
        final total = unlockedList.length + lockedList.length;
        homeController.unlockedCount.value = uCount;
        homeController.totalAchievementsCount.value = total;
        homeController.unlockedAchievements.value = '$uCount of $total unlocked';
        homeController.unlockedAchievementEmojis.value = unlockedList.map((e) => e.emoji).take(4).join(' ');
      }
    });
  }

  Future<void> fetchAchievements() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.achievements);

      if (response != null && (response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          final dashboard = AchievementsDashboardData.fromJson(data);

          // 1. Update streak
          currentStreak.value = dashboard.streak.currentStreakDays;
          streakTitle.value = dashboard.streak.streakTitle;
          streakMessage.value = dashboard.streak.streakMessage;

          // 2. Update financial health
          if (dashboard.financialHealthPercentage > 0) {
            financialHealthPercentage.value = dashboard.financialHealthPercentage;
          }

          // 3. Compute dynamic badges merged with server response
          int streak = currentStreak.value;
          double health = financialHealthPercentage.value;
          int subCount = 0;
          bool hasSavingsGoal = false;
          double savingsGoalProgress = 0.0;

          if (Get.isRegistered<HomeController>()) {
            final home = Get.find<HomeController>();
            if (health <= 0) health = home.healthScore.value.toDouble();
            if (streak <= 1) streak = home.streakCount.value;
            subCount = home.subscriptions.length;
            final goal = home.budgetDashboard.value?.savingsGoal;
            if (goal != null && (goal.title.isNotEmpty || goal.targetAmount > 0)) {
              hasSavingsGoal = true;
              savingsGoalProgress = goal.progressPercentage;
            }
          }

          _computeBadges(
            health: health,
            subCount: subCount,
            streak: streak,
            hasSavingsGoal: hasSavingsGoal,
            savingsGoalProgress: savingsGoalProgress,
            serverUnlocked: dashboard.unlocked,
            serverLocked: dashboard.locked,
          );
        }
      } else {
        _loadInitialFallbacks();
      }
    } catch (_) {
      _loadInitialFallbacks();
    } finally {
      isLoading.value = false;
    }
  }
}
