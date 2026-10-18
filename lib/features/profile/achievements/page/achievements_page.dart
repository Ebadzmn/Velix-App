import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/achievements_controller.dart';

class AchievementsPage extends GetView<AchievementsController> {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D0E15) : const Color(0xFFF4F5F9);
    final cardColor = isDark ? const Color(0xFF141521) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF242536) : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF9482FF);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    const greenColor = Color(0xFF00E676);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Achievements',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () => controller.fetchAchievements(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner 1: Streak Progress Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF251A18) : const Color(0xFFFFF7ED),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text('🔥', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.streakTitle.value,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Obx(
                              () => Text(
                                controller.streakMessage.value,
                                style: TextStyle(
                                  color: labelColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${controller.currentStreak.value} days',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Top Banner 2: Financial Health Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial health',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Text(
                              '${controller.financialHealthPercentage.value.toInt()} %',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Obx(() {
                            final progress = (controller.financialHealthPercentage.value / 100.0).clamp(0.0, 1.0);
                            return Container(
                              width: 160,
                              height: 6,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress == 0 ? 0.02 : progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // UNLOCKED Section Header & List
                Obx(() {
                  final unlocked = controller.unlockedList;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UNLOCKED · ${unlocked.length}',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: List.generate(unlocked.length, (index) {
                            final item = unlocked[index];
                            return Column(
                              children: [
                                _buildAchievementRow(
                                  emoji: item.emoji,
                                  emojiBgColor: isDark ? const Color(0xFF122421) : const Color(0xFFE6F9F0),
                                  title: item.title,
                                  subtitle: item.description,
                                  isUnlocked: true,
                                  greenColor: greenColor,
                                  labelColor: labelColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                ),
                                if (index < unlocked.length - 1)
                                  Divider(color: borderColor, height: 1),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),

                // LOCKED Section Header & List
                Obx(() {
                  final locked = controller.lockedList;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOCKED · ${locked.length}',
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: List.generate(locked.length, (index) {
                            final item = locked[index];
                            return Column(
                              children: [
                                _buildAchievementRow(
                                  emoji: item.emoji,
                                  emojiBgColor: isDark ? const Color(0xFF1B1C2A) : const Color(0xFFF3F4F6),
                                  title: item.title,
                                  subtitle: item.description,
                                  isUnlocked: false,
                                  greenColor: greenColor,
                                  labelColor: labelColor,
                                  textColor: textColor,
                                  isDark: isDark,
                                ),
                                if (index < locked.length - 1)
                                  Divider(color: borderColor, height: 1),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builder helper for achievement rows
  Widget _buildAchievementRow({
    required String emoji,
    required Color emojiBgColor,
    required String title,
    required String subtitle,
    required bool isUnlocked,
    required Color greenColor,
    required Color labelColor,
    required Color textColor,
    required bool isDark,
  }) {
    final titleColor = isUnlocked ? textColor : (isDark ? const Color(0xFF7D8094) : const Color(0xFF9CA3AF));
    final subtitleColor = isUnlocked ? labelColor : (isDark ? const Color(0xFF4E5063) : const Color(0xFFD1D5DB));
    final containerColor = isUnlocked ? emojiBgColor : (isDark ? const Color(0xFF161724) : const Color(0xFFF9FAFB));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: isUnlocked ? 1.0 : 0.35,
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (isUnlocked)
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF102922) : const Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: greenColor, size: 18),
            )
          else
            Icon(Icons.lock_outline, color: labelColor.withOpacity(0.5), size: 20),
        ],
      ),
    );
  }
}
