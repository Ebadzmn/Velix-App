import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/questionnaire_controller.dart';

class QuestionnairePage extends GetView<QuestionnaireController> {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0D0E15);
    const cardColor = Color(0xFF141521);
    const borderColor = Color(0xFF242536);
    const primaryColor = Color(0xFF9482FF);
    const labelColor = Color(0xFF9EA3B0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          // If Review Screen is active, show the "Everything is ready!" screen
          if (controller.isReviewScreenShown.value) {
            return _buildReviewScreen(context, controller, primaryColor, cardColor, labelColor);
          }

          // Otherwise show the Step-by-Step Questionnaire Flow
          final step = controller.currentStep.value;
          final total = controller.totalSteps;
          final progress = step / total;
          final stepData = controller.currentStepData;
          final textController = controller.currentController;

          return Column(
            children: [
              // Top Navigation & Step Indicator Header
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Arrow (if step > 1)
                        SizedBox(
                          width: 40,
                          child: step > 1
                              ? IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: controller.previousStep,
                                )
                              : null,
                        ),

                        // Header Step Text
                        Text(
                          'Hi ${controller.userName.value} ! Step $step / $total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Skip Button
                        TextButton(
                          onPressed: controller.skip,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress Bar Track
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 3,
                        color: const Color(0xFF1E1F30),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: MediaQuery.of(context).size.width * progress,
                        height: 3,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Main Question Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Step Emoji Icon Box
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF181928),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          stepData.icon,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Title
                      Text(
                        stepData.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        stepData.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: labelColor,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Step 3: Subscription Quick Add Grid View
                      if (step == 3)
                        _buildSubscriptionGrid(
                          context,
                          controller,
                          cardColor,
                          borderColor,
                          primaryColor,
                          labelColor,
                        )
                      // Step 4: Fixed Monthly Costs Category Grid View
                      else if (step == 4)
                        _buildFixedCostsGrid(
                          context,
                          controller,
                          cardColor,
                          borderColor,
                          primaryColor,
                          labelColor,
                        )
                      // Step 6: Savings Goal Selection Chips Grid View
                      else if (step == 6)
                        _buildSavingsGoalGrid(
                          controller,
                          cardColor,
                          borderColor,
                          primaryColor,
                          labelColor,
                        )
                      else
                        // Standard Input Box Card for Steps 1, 2, 5
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Text(
                                stepData.prefix,
                                style: const TextStyle(
                                  color: labelColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: textController,
                                  onChanged: (_) => controller.previewRevision.value++,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: stepData.hint,
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Bottom Continue Action Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.nextStep,
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
                        Text(
                          step == 6 ? 'Get started!' : 'Continue',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          step == 6 ? '🚀' : '→',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Builder for Step 3 Subscription Chips Grid
  Widget _buildSubscriptionGrid(
    BuildContext context,
    QuestionnaireController controller,
    Color cardColor,
    Color borderColor,
    Color primaryColor,
    Color labelColor,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: controller.subscriptions.map((item) {
        return Obx(() {
          final isSelected = item.isSelected.value;
          final curr = controller.userCurrency.value;
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                // If already selected, tap toggles off or allows re-editing
                controller.toggleSubscription(item);
              } else {
                // When selecting, ask user to confirm default price or edit price
                _showSubscriptionConfirmModal(context, controller, item, curr);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF222036) : cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? primaryColor : borderColor,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.formattedPrice(curr),
                    style: TextStyle(
                      color: isSelected ? primaryColor : labelColor,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  // Builder for Step 4 Fixed Costs 3-Column Grid
  Widget _buildFixedCostsGrid(
    BuildContext context,
    QuestionnaireController controller,
    Color cardColor,
    Color borderColor,
    Color primaryColor,
    Color labelColor,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: controller.fixedCosts.length,
      itemBuilder: (context, index) {
        final item = controller.fixedCosts[index];
        return Obx(() {
          final hasAmount = item.amount.value > 0;
          return GestureDetector(
            onTap: () => _showAddCostModal(context, controller, item),
            child: Container(
              decoration: BoxDecoration(
                color: hasAmount ? const Color(0xFF201E34) : cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasAmount ? primaryColor : borderColor,
                  width: hasAmount ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (hasAmount)
                    Text(
                      '${item.amount.value.toInt()} ${controller.userCurrency.value}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white54,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Builder for Step 6 Savings Goal Chips Grid
  Widget _buildSavingsGoalGrid(
    QuestionnaireController controller,
    Color cardColor,
    Color borderColor,
    Color primaryColor,
    Color labelColor,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.savingsGoals.map((item) {
        return Obx(() {
          final isSelected = item.isSelected.value;
          return GestureDetector(
            onTap: () => controller.selectSavingsGoal(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF222036) : cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? primaryColor : borderColor,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                    item.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  // Modal BottomSheet for Adding Cost
  void _showAddCostModal(
    BuildContext context,
    QuestionnaireController controller,
    FixedCostCategory category,
  ) {
    final nameController = TextEditingController(text: category.name);
    final amountController = TextEditingController(
      text: category.amount.value > 0 ? category.amount.value.toInt().toString() : '0',
    );
    final noteController = TextEditingController(text: category.note.value);

    const modalBgColor = Color(0xFF10111A);
    const cardColor = Color(0xFF161724);
    const borderColor = Color(0xFF262738);
    const labelColor = Color(0xFF9EA3B0);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: modalBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  const Text(
                    'Add cost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Field 1: Name
              const Text(
                'Name',
                style: TextStyle(color: labelColor, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Field 2: Monthly amount
              Text(
                'Monthly amount (${controller.userCurrency.value})',
                style: const TextStyle(color: labelColor, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        controller.userCurrency.value,
                        style: const TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Field 3: Notes (optional)
              const Text(
                'Notes (optional)',
                style: TextStyle(color: labelColor, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g. Comhem, 100 Mbit',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons: Cancel and Save
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: cardColor,
                          side: const BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final amt = double.tryParse(amountController.text) ?? 0.0;
                          controller.saveFixedCost(category, amt, noteController.text);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1F32),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'Save',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Modal asking to confirm standard price or edit subscription price
  void _showSubscriptionConfirmModal(
    BuildContext context,
    QuestionnaireController controller,
    SubscriptionItem item,
    String currency,
  ) {
    final priceController = TextEditingController(
      text: item.customPrice.value % 1 == 0
          ? item.customPrice.value.toInt().toString()
          : item.customPrice.value.toStringAsFixed(1),
    );

    const modalBgColor = Color(0xFF10111A);
    const cardColor = Color(0xFF161724);
    const borderColor = Color(0xFF262738);
    const labelColor = Color(0xFF9EA3B0);
    const primaryColor = Color(0xFF9482FF);

    final isEditing = false.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: modalBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add ${item.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Default monthly price: ${item.formattedPrice(currency)}',
                          style: const TextStyle(color: labelColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Confirmation / Edit Section
              Obx(() {
                if (!isEditing.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Monthly cost',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              item.formattedPrice(currency),
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  isEditing.value = true;
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: cardColor,
                                  side: const BorderSide(color: borderColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                                    SizedBox(width: 6),
                                    Text(
                                      'Edit price',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.updateSubscriptionPrice(item, item.customPrice.value);
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // In Edit Price Mode
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your actual price ($currency)',
                      style: const TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: primaryColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              currency,
                              style: const TextStyle(color: labelColor, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: priceController,
                              autofocus: true,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                isEditing.value = false;
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: cardColor,
                                side: const BorderSide(color: borderColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final enteredPrice = double.tryParse(priceController.text) ?? item.customPrice.value;
                                controller.updateSubscriptionPrice(item, enteredPrice);
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Save & Add',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Builder for Review / Success Screen ("Everything is ready!")
  Widget _buildReviewScreen(
    BuildContext context,
    QuestionnaireController controller,
    Color primaryColor,
    Color cardColor,
    Color labelColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Top Celebration Icon
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),

          // Main Title
          const Text(
            'Everything is ready!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          const Text(
            'Welcome to Velix — your personal financial assistant',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9EA3B0),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 28),

          // YOUR FINANCIAL SNAPSHOT Bright Purple Container Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR FINANCIAL SNAPSHOT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly income',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.calculatedMonthlyIncome} ${controller.userCurrency.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Money left',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.calculatedMoneyLeft} ${controller.userCurrency.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Subscription/month',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.calculatedSubscriptionCost} ${controller.userCurrency.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly savings',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Obx(
                            () => Text(
                              '${controller.calculatedMonthlySavings} ${controller.userCurrency.value}',
                              style: const TextStyle(
                                color: Colors.white,
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
                const SizedBox(height: 20),
                // Savings Goal Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        'Savings goal: ${controller.selectedSavingsGoalName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // AI COACH SAYS Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF242536)),
            ),
            child: Row(
              children: [
                const Text('🤖', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI COACH SAYS:',
                        style: TextStyle(
                          color: Color(0xFF9EA3B0),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(text: 'Welcome! Together we will improve your financial health step by step. '),
                            TextSpan(text: '🚀'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Go to dashboard Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Obx(
              () => controller.isSubmitting.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9482FF)),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: controller.goToDashboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go to dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
