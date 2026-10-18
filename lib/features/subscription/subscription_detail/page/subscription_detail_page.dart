import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/subscription_detail_controller.dart';

class SubscriptionDetailPage extends GetView<SubscriptionDetailController> {
  const SubscriptionDetailPage({super.key});

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Centered Icon Badge Circle
              Obx(
                () => Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: controller.bgColor.value,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.icon.value,
                    color: controller.iconColor.value,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Subscription Title Name
              Obx(
                () => Text(
                  controller.name.value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Price Subtitle
              Obx(
                () => Text(
                  controller.priceText.value,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Information Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    // Category Row
                    Obx(
                      () => _buildDetailRow(
                        'category'.tr,
                        controller.category.value,
                        labelColor,
                        textColor,
                      ),
                    ),
                    Divider(color: borderColor, height: 32),

                    // Next Payment Row
                    Obx(
                      () => _buildDetailRow(
                        'next_payment'.tr,
                        controller.nextPayment.value,
                        labelColor,
                        textColor,
                      ),
                    ),
                    Divider(color: borderColor, height: 32),

                    // Annual Cost Row
                    Obx(
                      () => _buildDetailRow(
                        'annual_cost'.tr,
                        controller.annualCost.value,
                        labelColor,
                        textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Cancel Subscription Action Button
              TextButton(
                onPressed: controller.cancelSubscription,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'cancel_subscription'.tr,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Builder helper for detail rows
  Widget _buildDetailRow(String label, String value, Color labelColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
