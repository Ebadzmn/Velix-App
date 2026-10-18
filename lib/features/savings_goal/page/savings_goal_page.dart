import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/savings_goal_list_controller.dart';
import '../models/savings_goal_item_model.dart';

class SavingsGoalPage extends GetView<SavingsGoalListController> {
  const SavingsGoalPage({super.key});

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
          'savings_goal'.tr,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Goal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showCreateGoalDialog(context, isDark, cardColor, borderColor, textColor, labelColor, primaryColor),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () => controller.fetchSavingsGoals(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Info Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7362E9), Color(0xFF9B81F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Smart Savings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.savings_outlined, color: Colors.white, size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Keep track of your dream purchases, vacation funds, and long term targets.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Goals List Section
                Text(
                  'YOUR GOALS',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),

                Obx(() {
                  if (controller.isLoading.value && controller.goals.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    );
                  }

                  if (controller.goals.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.flag_outlined, color: primaryColor, size: 30),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No savings goals yet',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Create your first savings goal to start building wealth step by step.',
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

                  return Column(
                    children: controller.goals.map((goal) {
                      return _buildGoalCard(
                        goal: goal,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        labelColor: labelColor,
                        primaryColor: primaryColor,
                        greenColor: greenColor,
                        isDark: isDark,
                        context: context,
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required SavingsGoalItemModel goal,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color labelColor,
    required Color primaryColor,
    required Color greenColor,
    required bool isDark,
    required BuildContext context,
  }) {
    final progress = (goal.progressPercentage / 100.0).clamp(0.0, 1.0);

    return Dismissible(
      key: Key(goal.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (_) => controller.deleteGoal(goal.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
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
                        Text(
                          goal.name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          goal.formattedSavedAndTarget,
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
                  '${goal.progressPercentage.toStringAsFixed(0)} %',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress Track Bar
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1F30) : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress == 0 ? 0.02 : progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Add Savings Deposit Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _showAddSavingsDialog(context, goal, isDark, cardColor, borderColor, textColor, labelColor, primaryColor),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle_outline, color: primaryColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Add Savings',
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
          ],
        ),
      ),
    );
  }

  void _showCreateGoalDialog(
    BuildContext context,
    bool isDark,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color labelColor,
    Color primaryColor,
  ) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    final savedController = TextEditingController(text: '0');

    Get.dialog(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'New Savings Goal',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goal Name', style: TextStyle(color: labelColor, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'e.g. Holiday, MacBook, Car',
                  hintStyle: TextStyle(color: labelColor.withOpacity(0.6)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1F30) : const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),

              Text('Target Amount (${controller.userCurrency.value})', style: TextStyle(color: labelColor, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: targetController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'e.g. 15000',
                  hintStyle: TextStyle(color: labelColor.withOpacity(0.6)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1F30) : const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),

              Text('Already Saved (${controller.userCurrency.value})', style: TextStyle(color: labelColor, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: savedController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: labelColor.withOpacity(0.6)),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1F30) : const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: labelColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              final name = nameController.text.trim();
              final target = double.tryParse(targetController.text.trim()) ?? 0.0;
              final saved = double.tryParse(savedController.text.trim()) ?? 0.0;

              if (name.isEmpty || target <= 0) {
                Get.snackbar('Required', 'Please enter a valid goal name and target amount.',
                    backgroundColor: const Color(0xFFFF3B30), colorText: Colors.white);
                return;
              }

              Get.back();
              controller.createGoal(name: name, targetAmount: target, savedAmount: saved);
            },
            child: const Text('Create Goal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAddSavingsDialog(
    BuildContext context,
    SavingsGoalItemModel goal,
    bool isDark,
    Color cardColor,
    Color borderColor,
    Color textColor,
    Color labelColor,
    Color primaryColor,
  ) {
    final depositController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Add to "${goal.name}"',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount to deposit (${goal.currency})', style: TextStyle(color: labelColor, fontSize: 13)),
            const SizedBox(height: 8),
            TextField(
              controller: depositController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'e.g. 500',
                hintStyle: TextStyle(color: labelColor.withOpacity(0.6)),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1F30) : const Color(0xFFF3F4F6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: labelColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              final amount = double.tryParse(depositController.text.trim()) ?? 0.0;
              if (amount <= 0) {
                Get.snackbar('Invalid Amount', 'Please enter a positive amount to deposit.',
                    backgroundColor: const Color(0xFFFF3B30), colorText: Colors.white);
                return;
              }
              Get.back();
              controller.addSavingsAmount(goalId: goal.id, additionalAmount: amount);
            },
            child: const Text('Add Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
