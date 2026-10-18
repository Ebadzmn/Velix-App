class AchievementItem {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final AchievementProgress? progress;

  AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    this.category = '',
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress,
  });

  factory AchievementItem.fromJson(Map<String, dynamic> json) {
    return AchievementItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      emoji: json['emoji']?.toString() ?? '🎯',
      category: json['category']?.toString() ?? '',
      isUnlocked: json['is_unlocked'] == true,
      unlockedAt: json['unlocked_at'] != null ? DateTime.tryParse(json['unlocked_at'].toString()) : null,
      progress: json['progress'] != null ? AchievementProgress.fromJson(json['progress'] as Map<String, dynamic>) : null,
    );
  }
}

class AchievementProgress {
  final double current;
  final double target;
  final double percentage;

  AchievementProgress({
    this.current = 0,
    this.target = 0,
    this.percentage = 0,
  });

  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      current: (json['current'] as num?)?.toDouble() ?? 0,
      target: (json['target'] as num?)?.toDouble() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class StreakData {
  final int currentStreakDays;
  final int longestStreakDays;
  final String streakTitle;
  final String streakMessage;

  StreakData({
    this.currentStreakDays = 1,
    this.longestStreakDays = 1,
    this.streakTitle = '1 day streak',
    this.streakMessage = 'Open the app every day to build your streak',
  });

  factory StreakData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return StreakData();
    return StreakData(
      currentStreakDays: (json['current_streak_days'] as num?)?.toInt() ?? 1,
      longestStreakDays: (json['longest_streak_days'] as num?)?.toInt() ?? 1,
      streakTitle: json['streak_title']?.toString() ?? '${(json['current_streak_days'] as num?)?.toInt() ?? 1} day streak',
      streakMessage: json['streak_message']?.toString() ?? 'Open the app every day to build your streak',
    );
  }
}

class AchievementsDashboardData {
  final StreakData streak;
  final double financialHealthPercentage;
  final int totalAchievements;
  final int unlockedCount;
  final int lockedCount;
  final List<AchievementItem> unlocked;
  final List<AchievementItem> locked;

  AchievementsDashboardData({
    required this.streak,
    this.financialHealthPercentage = 0.0,
    this.totalAchievements = 0,
    this.unlockedCount = 0,
    this.lockedCount = 0,
    this.unlocked = const [],
    this.locked = const [],
  });

  factory AchievementsDashboardData.fromJson(Map<String, dynamic> json) {
    final streak = StreakData.fromJson(json['streak'] as Map<String, dynamic>?);
    
    double fhPercent = 0.0;
    if (json['financial_health'] != null && json['financial_health'] is Map) {
      final fh = json['financial_health'] as Map<String, dynamic>;
      fhPercent = (fh['percentage'] as num?)?.toDouble() ?? (fh['score'] as num?)?.toDouble() ?? 0.0;
    }

    final summary = json['summary'] as Map<String, dynamic>?;
    final total = (summary?['total_achievements'] as num?)?.toInt() ?? 0;
    final unlockedC = (summary?['unlocked_count'] as num?)?.toInt() ?? 0;
    final lockedC = (summary?['locked_count'] as num?)?.toInt() ?? 0;

    final unlockedList = <AchievementItem>[];
    if (json['unlocked'] != null && json['unlocked'] is List) {
      unlockedList.addAll((json['unlocked'] as List).map((i) => AchievementItem.fromJson(i as Map<String, dynamic>)));
    }

    final lockedList = <AchievementItem>[];
    if (json['locked'] != null && json['locked'] is List) {
      lockedList.addAll((json['locked'] as List).map((i) => AchievementItem.fromJson(i as Map<String, dynamic>)));
    }

    return AchievementsDashboardData(
      streak: streak,
      financialHealthPercentage: fhPercent,
      totalAchievements: total > 0 ? total : unlockedList.length + lockedList.length,
      unlockedCount: unlockedC > 0 ? unlockedC : unlockedList.length,
      lockedCount: lockedC > 0 ? lockedC : lockedList.length,
      unlocked: unlockedList,
      locked: lockedList,
    );
  }
}
