import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/beta_program_controller.dart';

class BetaProgramPage extends GetView<BetaProgramController> {
  const BetaProgramPage({super.key});

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
          'Beta Programs',
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
              // Top Hero Purple Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B75FF), Color(0xFF9B87FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.code, color: Colors.white, size: 26),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Beta Programs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Join the waitlist for upcoming features',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // UPCOMING FEATURES Header
              Text(
                'UPCOMING FEATURES',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              // Feature 1: Bank Connection Beta Card
              Obx(() {
                final isJoined = controller.isBankConnectionJoined.value;
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2E2C48) : borderColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1F1D36) : const Color(0xFFEDE9FE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.link, color: primaryColor, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Bank Connection Beta',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF202133) : const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Q3 2026',
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Connect your bank account automatically',
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action Joined Button
                      GestureDetector(
                        onTap: controller.toggleBankConnection,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isJoined
                                ? (isDark ? const Color(0xFF1E1D33) : const Color(0xFFEDE9FE))
                                : primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isJoined ? Icons.check_circle_outline : Icons.add,
                                color: isJoined ? primaryColor : Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isJoined ? 'Joined!' : 'Join waitlist',
                                style: TextStyle(
                                  color: isJoined ? primaryColor : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Feature 2: Investment Beta Card
              Obx(() {
                final isJoined = controller.isInvestmentJoined.value;
                const greenColor = Color(0xFF00E676);
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1A3934) : borderColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF122B25) : const Color(0xFFE6F9F0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.trending_up, color: greenColor, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Investment Beta',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF202133) : const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Q4 2026',
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Track and analyze your portfolio',
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action Joined Button
                      GestureDetector(
                        onTap: controller.toggleInvestment,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isJoined
                                ? (isDark ? const Color(0xFF132B27) : const Color(0xFFE6F9F0))
                                : greenColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isJoined ? Icons.check_circle_outline : Icons.add,
                                color: isJoined ? greenColor : Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isJoined ? 'Joined!' : 'Join waitlist',
                                style: TextStyle(
                                  color: isJoined ? greenColor : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Feature 3: Velix Card Beta Card
              Obx(() {
                final isJoined = controller.isVelixCardJoined.value;
                const goldColor = Color(0xFFFFC107);
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? const Color(0xFF3B3322) : borderColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF292318) : const Color(0xFFFFF7ED),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.credit_card, color: goldColor, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Velix Card Beta',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF202133) : const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Q1 2027',
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Your smart payment card with insights',
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action Joined Button
                      GestureDetector(
                        onTap: controller.toggleVelixCard,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isJoined
                                ? (isDark ? const Color(0xFF282319) : const Color(0xFFFFF7ED))
                                : goldColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isJoined ? goldColor.withOpacity(0.6) : Colors.transparent,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isJoined ? Icons.check_circle_outline : Icons.add,
                                color: isJoined ? goldColor : Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isJoined ? 'Joined!' : 'Join waitlist',
                                style: TextStyle(
                                  color: isJoined ? goldColor : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Bottom Information Banner Card
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
                        'We\'ll notify you via push when you\'re in the beta. No additional purchase required.',
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
