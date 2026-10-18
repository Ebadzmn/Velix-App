import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/new_subscription_controller.dart';

class NewSubscriptionPage extends GetView<NewSubscriptionController> {
  const NewSubscriptionPage({super.key});

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
          'New subscription',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // POPULAR SERVICES Header
              Text(
                'POPULAR SERVICES',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Popular Services Horizontal List
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.popularServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = controller.popularServices[index];
                    return GestureDetector(
                      onTap: () => controller.selectPopularService(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: (item['color'] as Color).withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Obx(
                                  () => Text(
                                    '${item['price']} ${controller.currency.value}/month',
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Name Input Field
              Text(
                'Name',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: controller.nameController,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Netflix',
                    hintStyle: TextStyle(
                      color: labelColor.withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Billing Period Selector (Monthly vs Yearly)
              Text(
                'Billing Period',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Obx(() {
                  final isMonthly = controller.billingPeriod.value == 'monthly';
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setBillingPeriod('monthly'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isMonthly ? primaryColor.withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Monthly',
                              style: TextStyle(
                                color: isMonthly ? primaryColor : labelColor,
                                fontSize: 14,
                                fontWeight: isMonthly ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setBillingPeriod('yearly'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isMonthly ? primaryColor.withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Yearly',
                              style: TextStyle(
                                color: !isMonthly ? primaryColor : labelColor,
                                fontSize: 14,
                                fontWeight: !isMonthly ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Price (SEK) Input Field
              Obx(() => Text(
                'Price (${controller.currency.value}) per ${controller.billingPeriod.value == 'monthly' ? 'month' : 'year'}',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              )),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Obx(
                        () => Text(
                          controller.currency.value,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Category Section Header
              Text(
                'Category',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Category Chips Grid Wrap
              Obx(() {
                final selected = controller.selectedCategory.value;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.categories.map((cat) {
                    final catName = cat['name'] as String;
                    final catIcon = cat['icon'] as IconData;
                    final catColor = cat['color'] as Color;
                    final isSelected = selected == catName;

                    return GestureDetector(
                      onTap: () => controller.selectCategory(catName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? catColor.withOpacity(0.18)
                              : cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? catColor : borderColor,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              catIcon,
                              color: isSelected ? catColor : labelColor,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              catName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : textColor,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 36),

              // Save subscription Primary Button with loading indicator
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.saveSubscription,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Save subscription',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
