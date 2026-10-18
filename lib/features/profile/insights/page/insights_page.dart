import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../controller/insights_controller.dart';

class InsightsPage extends GetView<InsightsController> {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D0E15) : const Color(0xFFF4F5F9);
    final cardColor = isDark ? const Color(0xFF141521) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF242536) : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF9482FF);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

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
          'Insights',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & AI Coach Badge Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Insights',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.aiCoach),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1C38) : const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primaryColor.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.memory, color: primaryColor, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'AI Coach',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Economic Health Score Card (Glowing Purple Hero Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B75FF), Color(0xFF9B87FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Economic health score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Obx(
                              () => Text(
                                '${controller.healthScore.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(
                              ' /100',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Action Badge Pill (Status)
                    Obx(() {
                      final status = controller.healthStatus.value;
                      final isGood = status.toLowerCase() == 'good' || status.toLowerCase() == 'excellent';
                      final dotColor = isGood ? const Color(0xFF00E676) : const Color(0xFFFF453A);

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: dotColor, size: 10),
                            const SizedBox(width: 6),
                            Text(
                              status,
                              style: const TextStyle(
                                color: Colors.white,
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
              const SizedBox(height: 20),

              // Points Breakdown Card
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
                      'Points breakdown',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() => _buildBreakdownRow('Savings quota', controller.savingsQuota.value, textColor, labelColor)),
                    Divider(color: borderColor, height: 16),
                    Obx(() => _buildBreakdownRow('Subscription control', controller.subscriptionControl.value, textColor, labelColor)),
                    Divider(color: borderColor, height: 16),
                    Obx(() => _buildBreakdownRow('Budget control', controller.budgetControl.value, textColor, labelColor)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3 Metric Stat Cards Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1D33) : const Color(0xFFEDE9FE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.layers_outlined, color: primaryColor, size: 20),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Text(
                              '${controller.subscriptionCount.value}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Subscription',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF122B25) : const Color(0xFFE6F9F0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.calendar_today_outlined, color: Color(0xFF00E676), size: 18),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Text(
                              controller.annualCostText.value,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'A year',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2C2214) : const Color(0xFFFFF7ED),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.percent, color: Colors.orangeAccent, size: 20),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Text(
                              controller.percentageOfIncomeText.value,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Of income',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Smart Insights Header
              Text(
                'Smart insights',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              // Smart Insights Cards List
              Obx(() {
                if (controller.isLoading.value && controller.smartInsightsList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                }

                final list = controller.smartInsightsList;
                if (list.isNotEmpty) {
                  return Column(
                    children: list.map((item) {
                      IconData itemIcon;
                      Color iconColor;
                      Color iconBgColor;

                      switch (item.type.toLowerCase()) {
                        case 'warning':
                          itemIcon = Icons.warning_amber_rounded;
                          iconColor = const Color(0xFFFF5252);
                          iconBgColor = isDark ? const Color(0xFF2C141E) : const Color(0xFFFEE2E2);
                          break;
                        case 'success':
                          itemIcon = Icons.check_circle_outline;
                          iconColor = const Color(0xFF00E676);
                          iconBgColor = isDark ? const Color(0xFF122B25) : const Color(0xFFE6F9F0);
                          break;
                        case 'alert':
                          itemIcon = Icons.trending_up;
                          iconColor = Colors.orangeAccent;
                          iconBgColor = isDark ? const Color(0xFF2C2214) : const Color(0xFFFFF7ED);
                          break;
                        case 'info':
                        default:
                          itemIcon = Icons.insights_outlined;
                          iconColor = primaryColor;
                          iconBgColor = isDark ? const Color(0xFF1E1D33) : const Color(0xFFEDE9FE);
                          break;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSmartInsightCard(
                          icon: itemIcon,
                          iconColor: iconColor,
                          iconBgColor: iconBgColor,
                          title: item.title,
                          text: item.message,
                          action: item.action,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          textColor: textColor,
                          labelColor: labelColor,
                          primaryColor: primaryColor,
                        ),
                      );
                    }).toList(),
                  );
                }

                // Fallback default cards if API returns empty
                return Column(
                  children: [
                    _buildSmartInsightCard(
                      icon: Icons.layers_outlined,
                      iconColor: primaryColor,
                      iconBgColor: isDark ? const Color(0xFF1E1D33) : const Color(0xFFEDE9FE),
                      title: 'Subscription Summary',
                      text: 'You have ${controller.subscriptionCount.value} active subscriptions that cost ${controller.annualCostText.value} per year.',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      labelColor: labelColor,
                      primaryColor: primaryColor,
                    ),
                    const SizedBox(height: 12),
                    _buildSmartInsightCard(
                      icon: Icons.trending_up,
                      iconColor: Colors.orangeAccent,
                      iconBgColor: isDark ? const Color(0xFF2C2214) : const Color(0xFFFFF7ED),
                      title: 'Income Impact',
                      text: 'Your subscriptions make up ${controller.percentageOfIncomeText.value} of your income.',
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      labelColor: labelColor,
                      primaryColor: primaryColor,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),

              // Ask AI Coach Banner Card
              GestureDetector(
                onTap: () => Get.toNamed(Routes.aiCoach),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.memory, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ask AI Coach',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Get personalized advice based on your finances',
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward, color: primaryColor, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Builder helper for breakdown rows
  Widget _buildBreakdownRow(String title, String percent, Color textColor, Color labelColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: labelColor,
            fontSize: 14,
          ),
        ),
        Text(
          percent,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Builder helper for smart insight cards
  Widget _buildSmartInsightCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    String? title,
    required String text,
    Map<String, dynamic>? action,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color labelColor,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && title.trim().isNotEmpty) ...[
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (action != null && action['label'] != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  final screen = action['screen']?.toString();
                  if (screen != null && screen.isNotEmpty) {
                    if (screen.contains('subscription')) {
                      Get.toNamed(Routes.home);
                    } else if (screen.contains('ai') || screen.contains('coach')) {
                      Get.toNamed(Routes.aiCoach);
                    } else if (screen.contains('budget')) {
                      Get.toNamed(Routes.home);
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action['label']?.toString() ?? 'View Details',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 10, color: primaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
