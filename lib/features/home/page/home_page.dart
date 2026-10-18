import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/utils/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

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
      body: SafeArea(
        child: Obx(() {
          final tabIndex = controller.selectedIndex.value;
          if (tabIndex == 1) {
            return _buildSubscriptionPageView(controller, primaryColor, cardColor, borderColor, labelColor, textColor);
          }
          if (tabIndex == 2) {
            return _buildCostsPageView(controller, primaryColor, cardColor, borderColor, labelColor, textColor);
          }
          if (tabIndex == 3) {
            return _buildBudgetPageView(controller, primaryColor, cardColor, borderColor, labelColor, greenColor, textColor);
          }
          if (tabIndex == 4) {
            return _buildProfilePageView(controller, primaryColor, cardColor, borderColor, labelColor, textColor, isDark);
          }
          return _buildHomeDashboardView(context, controller, primaryColor, cardColor, borderColor, labelColor, greenColor, textColor, isDark);
        }),
      ),

      // Bottom Navigation Bar (5 Tabs)
      bottomNavigationBar: _buildPremiumBottomNavBar(controller, primaryColor, labelColor, backgroundColor, borderColor),
    );
  }

  // Builder for Home Dashboard View (Tab 0)
  Widget _buildHomeDashboardView(
    BuildContext context,
    HomeController controller,
    Color primaryColor,
    Color cardColor,
    Color borderColor,
    Color labelColor,
    Color greenColor,
    Color textColor,
    bool isDark,
  ) {
    final badgeBg = isDark ? const Color(0xFF1C1929) : const Color(0xFFEDE9FE);
    final iconBg = isDark ? const Color(0xFF1F2034) : const Color(0xFFF3F0FF);
    final greenBg = isDark ? const Color(0xFF122A23) : const Color(0xFFE6F9F0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'good_morning'.tr,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('👋', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'health_score'.tr,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Action Badges (Streak, AI Chip, Notification)
              Row(
                children: [
                  // Streak Flame Badge (Navigates to Achievements)
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.achievements),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Obx(
                            () => Text(
                              '${controller.streakCount.value}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // AI Chip Icon (Navigates to AI Coach)
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.aiCoach),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.memory, color: primaryColor, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Notification Bell Icon (Navigates to Notifications Screen with unread badge)
                  GestureDetector(
                    onTap: () async {
                      await Get.toNamed(Routes.notifications);
                      controller.fetchUnreadNotificationsCount();
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: badgeBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.notifications_none_outlined, color: textColor, size: 20),
                        ),
                        Obx(() {
                          final unread = controller.unreadNotificationsCount.value;
                          if (unread <= 0) return const SizedBox.shrink();
                          return Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF3B30),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Economic Health Score Card (Bright Purple Card)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7362E9), Color(0xFF9B81F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7362E9).withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'economic_health_score'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          '${controller.healthScore.value} %',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 12),
                      Text(
                        'left_this_month'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          '${controller.leftThisMonth.value} ${controller.userCurrency.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          'days_left'.trParams({'days': '${controller.daysLeft.value}'}),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Donut Ring Indicator with progress
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() {
                        final score = controller.healthScore.value.clamp(0, 100);
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: score / 100.0,
                            strokeWidth: 10,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeCap: StrokeCap.round,
                          ),
                        );
                      }),
                      Obx(
                        () => Text(
                          '${controller.healthScore.value}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Two Stats Cards (Subscription /month & Next draw)
          Row(
            children: [
              // Card 1: Subscription /month
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: iconBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.sync, color: primaryColor, size: 20),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'subscription_per_month'.tr,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          '${controller.monthlySubscriptionTotal.value} ${controller.userCurrency.value}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Card 2: Next draw
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A2219) : const Color(0xFFFFF7ED),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.access_time, color: Colors.amber, size: 20),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'next_draw'.tr,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() {
                        final currentIndex = controller.nextDrawIndex.value;
                        final name = controller.nextDrawName.value;
                        final price = controller.nextDrawPrice.value;

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            final inAnimation = Tween<Offset>(
                              begin: const Offset(0.0, 0.4),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ));

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: inAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            key: ValueKey<String>('${currentIndex}_$name'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                price,
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Safe to Spend Today Banner Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: greenBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shield_outlined, color: greenColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'safe_to_spend_today'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Obx(
                              () => Text(
                                '${controller.safeToSpendToday.value} ${controller.userCurrency.value}',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Ask AI Coach Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF221D40) : const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.memory, color: primaryColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'ask_ai_coach'.tr,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Subscription Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'nav_subscription'.tr,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => controller.changeTab(1),
                child: Text(
                  'see_all'.tr,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Subscription Items List
          Obx(() {
            if (controller.subscriptions.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Text(
                    'No active subscriptions',
                    style: TextStyle(color: labelColor, fontSize: 14),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.subscriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = controller.subscriptions[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.subscriptionDetail, arguments: item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: item.bgColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(item.icon, color: item.iconColor, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.formattedDate,
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          item.formattedPrice,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 24),

          // Fixed Costs Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'fixed_costs'.tr,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF102922) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Obx(
                  () => Text(
                    controller.fixedCostsTotal.value,
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dynamic Fixed Costs List
          Obx(() {
            final fixedCosts = controller.fixedCosts;
            if (fixedCosts.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Text(
                    'No fixed costs registered',
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: fixedCosts.map((cost) {
                final icon = _getFixedCostIcon(cost.category);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Text(
                            cost.category,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${cost.amount.toInt()} ${controller.userCurrency.value}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 14),

          // Savings Goal Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'savings_goal'.tr,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.savingsGoals);
                  controller.fetchBudgetDashboard();
                },
                child: Text(
                  'see_all'.tr,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Savings Goal Item Card
          GestureDetector(
            onTap: () async {
              await Get.toNamed(Routes.savingsGoals);
              controller.fetchBudgetDashboard();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2016) : const Color(0xFFFFF7ED),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.sunny,
                              color: Colors.orangeAccent,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  controller.savingsGoalTitle.value,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Obx(
                                () => Text(
                                  controller.savedAmountText.value,
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Obx(
                        () => Text(
                          controller.savingsPercentageText.value,
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Savings Progress Track Bar
                  Obx(() {
                    final goal = controller.budgetDashboard.value?.savingsGoal;
                    final progress = goal != null ? (goal.progressPercentage / 100.0).clamp(0.0, 1.0) : 0.0;
                    return Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1F30) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress == 0 ? 0.02 : progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Builder for Subscription Page View matching user screenshot (Tab 1)
  Widget _buildSubscriptionPageView(
    HomeController controller,
    Color primaryColor,
    Color cardColor,
    Color borderColor,
    Color labelColor,
    Color textColor,
  ) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchSubscriptionDashboard(),
      color: primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            Text(
              'nav_subscription'.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Segmented Toggle Switch (Total per month vs Total per year)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Obx(() {
                final isPerYear = controller.isPerYear.value;
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.toggleSubscriptionPeriod(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isPerYear ? primaryColor.withOpacity(0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'total_per_month'.tr,
                            style: TextStyle(
                              color: !isPerYear ? primaryColor : labelColor,
                              fontSize: 14,
                              fontWeight: !isPerYear ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.toggleSubscriptionPeriod(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isPerYear ? primaryColor.withOpacity(0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'total_per_year'.tr,
                            style: TextStyle(
                              color: isPerYear ? primaryColor : labelColor,
                              fontSize: 14,
                              fontWeight: isPerYear ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),

            // Total Summary Card with Proportion Bars
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final summary = controller.subscriptionSummary.value;
                    final total = controller.isPerYear.value
                        ? summary.totalPerYear
                        : summary.totalPerMonth;
                    final formattedTotal = total % 1 == 0 ? total.toInt().toString() : total.toStringAsFixed(1);
                    return Text(
                      '$formattedTotal ${summary.currency}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      'active_subscriptions_count'.trParams({'count': '${controller.subscriptions.length}'}),
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Proportion Blocks matching dynamic subscriptions
                  Obx(() {
                    if (controller.subscriptions.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: controller.subscriptions.take(5).map((sub) {
                        final summary = controller.subscriptionSummary.value;
                        final total = summary.totalPerMonth > 0 ? summary.totalPerMonth : 1.0;
                        final flexVal = ((sub.price / total) * 10).clamp(1, 10).toInt();
                        final heightVal = (30.0 + (sub.price / total) * 25).clamp(24.0, 52.0);
                        return Expanded(
                          flex: flexVal,
                          child: Container(
                            height: heightVal,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: sub.iconColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // All Subscriptions Header
            Text(
              'all_subscriptions'.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Subscriptions List or Loading or Empty State
            Obx(() {
              if (controller.isLoadingSubscriptions.value && controller.subscriptions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              if (controller.subscriptions.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.subscriptions_outlined, color: primaryColor, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No Subscriptions Yet',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap the button below to add your first subscription.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.subscriptions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.subscriptions[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.subscriptionDetail, arguments: item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: item.bgColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(item.icon, color: item.iconColor, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.formattedDate} · ${item.category}',
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            item.formattedPrice,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 28),

            // + Add Subscription Primary Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.newSubscription),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'add_subscription'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Builder for Costs Page View matching user screenshot (Tab 2)
  Widget _buildCostsPageView(
    HomeController controller,
    Color primaryColor,
    Color cardColor,
    Color borderColor,
    Color labelColor,
    Color textColor,
  ) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchVariableCostsDashboard(),
      color: primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            Text(
              'variable_costs'.tr,
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Description Text
            Text(
              'variable_costs_desc'.tr,
              style: TextStyle(
                color: labelColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // + Add cost Primary Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.addCost),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'add_cost'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Information Banner Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: labelColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'variable_costs_info_banner'.tr,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Card (Variable costs this month)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'variable_costs_this_month'.tr,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => Text(
                      '${controller.totalVariableCostsAmount} ${controller.userCurrency.value}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      'transactions_count'.trParams({'count': '${controller.variableCosts.length}'}),
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Filter Chips Row (This month, Last month, Last 3 months, All)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final activeFilter = controller.selectedCostsFilter.value;
                return Row(
                  children: controller.costsFilters.map((filter) {
                    final isSelected = activeFilter == filter;
                    String displayFilter = filter;
                    if (filter == 'This month') displayFilter = 'filter_this_month'.tr;
                    if (filter == 'Last month') displayFilter = 'filter_last_month'.tr;
                    if (filter == 'Last 3 months') displayFilter = 'filter_last_3_months'.tr;
                    if (filter == 'All') displayFilter = 'filter_all'.tr;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () => controller.selectCostsFilter(filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? primaryColor : borderColor,
                            ),
                          ),
                          child: Text(
                            displayFilter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : labelColor,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Dynamic Transactions List View vs Empty State
            Obx(() {
              if (controller.isLoadingCosts.value && controller.variableCosts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              if (controller.variableCosts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.credit_card_outlined,
                            color: primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_variable_costs'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'no_variable_costs_desc'.tr,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'transactions'.tr,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.variableCosts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = controller.variableCosts[index];
                      return Dismissible(
                        key: Key(item.id.isNotEmpty ? item.id : 'cost_$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
                        ),
                        confirmDismiss: (direction) async {
                          return await Get.dialog<bool>(
                            AlertDialog(
                              backgroundColor: const Color(0xFF141521),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text(
                                'Delete ${item.title}?',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Are you sure you want to delete this cost entry?',
                                style: TextStyle(color: Color(0xFF9EA3B0)),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF9EA3B0))),
                                ),
                                ElevatedButton(
                                  onPressed: () => Get.back(result: true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF3B30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ) ?? false;
                        },
                        onDismissed: (direction) {
                          if (item.id.isNotEmpty) {
                            controller.deleteVariableCost(item.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: item.bgColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(item.icon, color: item.iconColor, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.formattedDate} · ${item.category}',
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                item.formattedAmount,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Builder for Budget Page View matching user screenshot (Tab 3)
  Widget _buildBudgetPageView(
    HomeController controller,
    Color primaryColor,
    Color cardColor,
    Color borderColor,
    Color labelColor,
    Color greenColor,
    Color textColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          Text(
            'nav_budget'.tr,
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Circular Progress Chart Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                  // Donut Circle Chart
                  Container(
                    width: 190,
                    height: 190,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                        width: 14,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '${controller.budgetMoneyLeft.value}\n${controller.userCurrency.value}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  height: 1.15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'left_this_month'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Safe to spend today
                Text(
                  'safe_to_spend_today'.tr,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${controller.safeToSpendToday.value} ${controller.userCurrency.value}',
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Financial Breakdown List
          _buildBudgetItem(
            dotColor: greenColor,
            title: 'income'.tr,
            amount: Obx(() => Text('${controller.budgetIncome.value} ${controller.userCurrency.value}', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))),
            textColor: textColor,
          ),
          Divider(color: borderColor, height: 1),
          _buildBudgetItem(
            dotColor: const Color(0xFFFFA726),
            title: 'fixed_expenses'.tr,
            amount: Obx(() => Text('${controller.budgetFixedExpenses.value} ${controller.userCurrency.value}', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))),
            textColor: textColor,
          ),
          Divider(color: borderColor, height: 1),
          _buildBudgetItem(
            dotColor: primaryColor,
            title: 'nav_subscription'.tr,
            amount: Obx(() => Text('${controller.budgetSubscription.value} ${controller.userCurrency.value}', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))),
            textColor: textColor,
          ),
          Divider(color: borderColor, height: 1),
          _buildBudgetItem(
            dotColor: const Color(0xFF00E676),
            title: 'monthly_savings'.tr,
            amount: Obx(() => Text('${controller.budgetMonthlySavings.value} ${controller.userCurrency.value}', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))),
            textColor: textColor,
          ),
          Divider(color: borderColor, height: 1),
          _buildBudgetItem(
            dotColor: const Color(0xFFFF3B30),
            title: 'money_left'.tr,
            amount: Obx(() => Text('${controller.budgetMoneyLeft.value} ${controller.userCurrency.value}', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))),
            textColor: textColor,
          ),
          const SizedBox(height: 24),

          // Warning Alert Banner (Shown only when overspent)
          Obx(() {
            if (controller.isBudgetOverspent.value || controller.budgetOverspentAmount.value > 0) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27151B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF4A1C24)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFFF453A),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'overspent_warning'.trParams({'amount': '${controller.budgetOverspentAmount.value}'}),
                            style: const TextStyle(
                              color: Color(0xFFFF453A),
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Savings Goal Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'savings_goal'.tr,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'see_all'.tr,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Savings Goal Item Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2A2016),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.sunny,
                            color: Colors.orangeAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.savingsGoalTitle.value,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Obx(
                              () => Text(
                                controller.savedAmountText.value,
                                style: TextStyle(
                                  color: labelColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Obx(
                      () => Text(
                        controller.savingsPercentageText.value,
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Savings Progress Track Bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 4,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Obx(() {
                          final pct = (controller.budgetDashboard.value?.savingsGoal.progressPercentage ?? 0.0).clamp(0.0, 100.0) / 100.0;
                          return Container(
                            width: constraints.maxWidth * pct,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Builder helper for budget item rows
  Widget _buildBudgetItem({
    required Color dotColor,
    required String title,
    required Widget amount,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          amount,
        ],
      ),
    );
  }

  // Builder for Profile Page View matching user screenshot (Tab 4)
  Widget _buildProfilePageView(
    HomeController controller,
    Color primaryColor,
    Color cardColor,
    Color borderColor,
    Color labelColor,
    Color textColor,
    bool isDark,
  ) {
    final avatarBg = isDark ? const Color(0xFF1F2034) : const Color(0xFFEDE9FE);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          Text(
            'nav_profile'.tr,
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Main User Profile Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                // Avatar Circle
                Obx(() {
                  final imagePath = controller.userProfileImage.value;
                  final uri = Uri.tryParse(imagePath);
                  final imageUrl = imagePath.isEmpty
                      ? null
                      : uri?.hasScheme == true
                          ? imagePath
                          : '${AppConstants.baseUrl}$imagePath';
                  final initials = controller.userFullName.value
                      .trim()
                      .split(RegExp(r'\\s+'))
                      .where((part) => part.isNotEmpty)
                      .map((part) => part[0])
                      .take(2)
                      .join()
                      .toUpperCase();

                  return CircleAvatar(
                    radius: 26,
                    backgroundColor: avatarBg,
                    backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
                    child: imageUrl == null
                        ? Text(
                            initials.isEmpty ? 'U' : initials,
                            style: TextStyle(
                              color: isDark ? Colors.white : primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  );
                }),
                const SizedBox(width: 14),

                // Name, Email, Badge Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.userFullName.value,
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
                          controller.userEmail.value,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Early Adopter Badge Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2518) : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(
                          () => Text(
                            controller.userBadge.value,
                            style: const TextStyle(
                              color: Color(0xFFFFC107),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Icon & Health Score Badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: labelColor, size: 20),
                      onPressed: () => Get.toNamed(Routes.editProfile),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF291920) : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Obx(
                            () => Text(
                              '${controller.healthScore.value} %',
                              style: const TextStyle(
                                color: Color(0xFFFF3B30),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'health_score'.tr,
                            style: const TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3 Stats Cards Row (Income /month, Left, Subscription)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'income_per_month'.tr,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(
                        () => Text(
                          '${controller.budgetIncome.value} ${controller.userCurrency.value}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'left'.tr,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(
                        () => Text(
                          '${controller.budgetMoneyLeft.value} ${controller.userCurrency.value}',
                          style: const TextStyle(
                            color: Color(0xFFFF3B30),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nav_subscription'.tr,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(
                        () => Text(
                          '${controller.monthlySubscriptionTotal.value} ${controller.userCurrency.value}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Upgrade to Premium Card
          GestureDetector(
            onTap: () => Get.toNamed(Routes.upgradePremium),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flash_on, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'upgrade_to_premium'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'upgrade_to_premium_sub'.tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Achievements Summary Card
          GestureDetector(
            onTap: () => Get.toNamed(Routes.achievements),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'achievements'.tr,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          controller.unlockedAchievements.value,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          controller.unlockedAchievementEmojis.value.isNotEmpty
                              ? controller.unlockedAchievementEmojis.value
                              : '🎯 💎',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: labelColor, size: 22),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // TOOL Section Header
          Text(
            'tool_section'.tr,
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // TOOL Group Container
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildProfileOptionRow(
                  icon: Icons.memory,
                  title: 'ai_coach'.tr,
                  subtitle: 'ai_coach_sub'.tr,
                  isPremium: true,
                  onTap: () => Get.toNamed(Routes.aiCoach),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.bar_chart,
                  title: 'insights'.tr,
                  subtitle: 'insights_sub'.tr,
                  isPremium: true,
                  onTap: () => Get.toNamed(Routes.insights),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                Obx(
                  () => _buildProfileOptionRow(
                    icon: Icons.emoji_events_outlined,
                    title: 'achievements'.tr,
                    subtitle: controller.unlockedAchievements.value,
                    isPremium: false,
                    onTap: () => Get.toNamed(Routes.achievements),
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    avatarBg: avatarBg,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ACCOUNT Section Header
          Text(
            'account_section'.tr,
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // ACCOUNT Group Container
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildProfileOptionRow(
                  icon: Icons.person_outline,
                  title: 'edit_profile'.tr,
                  subtitle: 'edit_profile_sub'.tr,
                  isPremium: false,
                  onTap: () => Get.toNamed(Routes.editProfile),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.settings_outlined,
                  title: 'settings'.tr,
                  subtitle: 'settings_sub'.tr,
                  isPremium: false,
                  onTap: () => Get.toNamed(Routes.settings),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.code,
                  title: 'beta_program'.tr,
                  subtitle: 'beta_program_sub'.tr,
                  isPremium: false,
                  onTap: () => Get.toNamed(Routes.betaProgram),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.link,
                  title: 'bank_connection'.tr,
                  subtitle: 'bank_connection_sub'.tr,
                  isPremium: false,
                  rightBadgeText: 'soon'.tr,
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.notifications_none_outlined,
                  title: 'notifications'.tr,
                  subtitle: 'notifications_sub'.tr,
                  isPremium: false,
                  onTap: () => Get.toNamed(Routes.notifications),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // SUPPORT Section Header
          Text(
            'support_section'.tr,
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // SUPPORT Group Container
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildProfileOptionRow(
                  icon: Icons.help_outline,
                  title: 'help_support'.tr,
                  isPremium: false,
                  onTap: () => Get.toNamed(Routes.helpSupport),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.shield_outlined,
                  title: 'privacy_policy'.tr,
                  isPremium: false,
                  onTap: () => Get.toNamed(Routes.privacyPolicy),
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
                Divider(color: borderColor, height: 1),
                _buildProfileOptionRow(
                  icon: Icons.star_outline,
                  title: 'rate_velix'.tr,
                  isPremium: false,
                  primaryColor: primaryColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  avatarBg: avatarBg,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Velix Version Footer Text
          Center(
            child: Text(
              'made_with_love'.tr,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Builder helper for option rows in TOOL, ACCOUNT & SUPPORT sections
  Widget _buildProfileOptionRow({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isPremium = false,
    String? rightBadgeText,
    VoidCallback? onTap,
    required Color primaryColor,
    required Color labelColor,
    required Color textColor,
    required Color avatarBg,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: avatarBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: primaryColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null && subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF221D40),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'premium'.tr,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (rightBadgeText != null && rightBadgeText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  rightBadgeText,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right, color: labelColor, size: 22),
          ],
        ),
      ),
    );
  }

  // Builder for Bottom Navigation Bar matching Original Image
  Widget _buildPremiumBottomNavBar(
    HomeController controller,
    Color primaryColor,
    Color labelColor,
    Color backgroundColor,
    Color borderColor,
  ) {
    final navItems = [
      {'key': 'nav_home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home},
      {'key': 'nav_subscription', 'icon': Icons.sync, 'activeIcon': Icons.sync},
      {'key': 'nav_costs', 'icon': Icons.credit_card_outlined, 'activeIcon': Icons.credit_card},
      {'key': 'nav_budget', 'icon': Icons.pie_chart_outline, 'activeIcon': Icons.pie_chart},
      {'key': 'nav_profile', 'icon': Icons.person_outline, 'activeIcon': Icons.person},
    ];

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            return Obx(() {
              final isSelected = controller.selectedIndex.value == index;
              final item = navItems[index];
              final label = (item['key'] as String).tr;

              return InkWell(
                onTap: () => controller.changeTab(index),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (isSelected ? item['activeIcon'] : item['icon']) as IconData,
                        color: isSelected ? primaryColor : labelColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? primaryColor : labelColor,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }),
        ),
      ),
    );
  }

  String _getFixedCostIcon(String category) {
    final lower = category.toLowerCase().trim();
    if (lower.contains('gym') || lower.contains('fitness') || lower.contains('training') || lower.contains('health')) {
      return '🏋️';
    }
    if (lower.contains('insurance') || lower.contains('försäkring') || lower.contains('assurance') || lower.contains('seguro') || lower.contains('versicherung')) {
      return '🛡️';
    }
    if (lower.contains('rent') || lower.contains('hyra') || lower.contains('loyer') || lower.contains('alquiler') || lower.contains('miete') || lower.contains('housing') || lower.contains('house')) {
      return '🏠';
    }
    if (lower.contains('phone') || lower.contains('mobil') || lower.contains('telefon') || lower.contains('mobile')) {
      return '📱';
    }
    if (lower.contains('internet') || lower.contains('wifi') || lower.contains('broadband') || lower.contains('bredband')) {
      return '🌐';
    }
    if (lower.contains('loan') || lower.contains('lån') || lower.contains('credit') || lower.contains('kredit') || lower.contains('prêt') || lower.contains('préstamo')) {
      return '💳';
    }
    if (lower.contains('transport') || lower.contains('pendel') || lower.contains('bus') || lower.contains('train') || lower.contains('commute')) {
      return '🚌';
    }
    if (lower.contains('car') || lower.contains('bil') || lower.contains('auto') || lower.contains('voiture')) {
      return '🚗';
    }
    if (lower.contains('electricity') || lower.contains('el') || lower.contains('power') || lower.contains('strom')) {
      return '⚡';
    }
    return '📌';
  }
}
