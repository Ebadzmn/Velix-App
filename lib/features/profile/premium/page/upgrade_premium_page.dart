import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/premium_controller.dart';

class UpgradePremiumPage extends GetView<PremiumController> {
  const UpgradePremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0B0C12) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF141522) : const Color(0xFFFFFFFF);
    final cardSecondaryColor = isDark ? const Color(0xFF1B1D2E) : const Color(0xFFF9FAFC);
    final borderColor = isDark ? const Color(0xFF24273E) : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF9482FF);
    const accentGold = Color(0xFFFFB800);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Ambient luxury background glow
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(isDark ? 0.35 : 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accentGold.withOpacity(isDark ? 0.15 : 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Custom Header / App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          backgroundColor: cardColor.withOpacity(0.8),
                          shape: const CircleBorder(),
                        ),
                        icon: Icon(Icons.arrow_back, color: textColor, size: 20),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accentGold.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium, color: accentGold, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'vip_exclusive'.tr,
                              style: const TextStyle(
                                color: accentGold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.snackbar('help_support'.tr, 'Our VIP concierge is available 24/7.');
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: cardColor.withOpacity(0.8),
                          shape: const CircleBorder(),
                        ),
                        icon: Icon(Icons.headset_mic_outlined, color: textColor, size: 20),
                      ),
                    ],
                  ),
                ),

                // Main Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        // Animated / Glowing Crown Badge
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD54F), Color(0xFFFF9800), Color(0xFF9482FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFB800).withOpacity(0.45),
                                blurRadius: 24,
                                spreadRadius: 2,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Title & Subtitle
                        Text(
                          'unlock_premium_title'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'unlock_premium_subtitle'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Pricing Card (Monthly Subscription Only - 25 kr Price)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      const Color(0xFF1E1C38),
                                      const Color(0xFF161726),
                                    ]
                                  : [
                                      const Color(0xFFFFFFFF),
                                      const Color(0xFFF4F3FF),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.6),
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(isDark ? 0.22 : 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.18),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.bolt, color: primaryColor, size: 20),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'monthly_sub_title'.tr,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'monthly_sub_desc'.tr,
                                            style: TextStyle(
                                              color: labelColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF9482FF), Color(0xFF7A65FF)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'popular_badge'.tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Divider(color: borderColor, height: 1),
                              const SizedBox(height: 18),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Obx(() => Text(
                                    controller.displayPrice.value,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  )),
                                  const SizedBox(width: 6),
                                  Text(
                                    'per_month'.tr,
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 16),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Obx(() => Text(
                                      'billed_monthly_note'.tr.replaceAll('25 kr', controller.displayPrice.value),
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFF00E676) : const Color(0xFF059669),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Section Title: Everything included
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'whats_included'.tr,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Feature Cards List
                        ...controller.features.map((feature) {
                          IconData iconData;
                          Color iconColor;

                          switch (feature['icon']) {
                            case 'flash':
                              iconData = Icons.psychology;
                              iconColor = const Color(0xFF9482FF);
                              break;
                            case 'sync':
                              iconData = Icons.sync_alt_rounded;
                              iconColor = const Color(0xFF00E676);
                              break;
                            case 'shield':
                              iconData = Icons.security_rounded;
                              iconColor = const Color(0xFFFF5252);
                              break;
                            case 'chart':
                              iconData = Icons.insights_rounded;
                              iconColor = const Color(0xFFFFB800);
                              break;
                            case 'folder':
                              iconData = Icons.file_download_outlined;
                              iconColor = const Color(0xFF00B0FF);
                              break;
                            case 'star':
                            default:
                              iconData = Icons.workspace_premium_rounded;
                              iconColor = const Color(0xFFFFD54F);
                              break;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: iconColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(iconData, color: iconColor, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (feature['titleKey'] as String).tr,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (feature['subtitleKey'] as String).tr,
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 13,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF00E676),
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 20),

                        // Guarantee Trust Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardSecondaryColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E676).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_user_outlined,
                                  color: Color(0xFF00E676),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'risk_free_title'.tr,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'risk_free_desc'.tr,
                                      style: TextStyle(
                                        color: labelColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Restore Purchases Action Button
                        Center(
                          child: Obx(() {
                            final isRestoring = controller.isRestoring.value;
                            return TextButton.icon(
                              onPressed: isRestoring ? null : controller.restorePurchases,
                              icon: isRestoring
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
                                    )
                                  : const Icon(Icons.restore, color: primaryColor, size: 18),
                              label: Text(
                                isRestoring ? 'Restoring purchases...' : 'Restore Purchases',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // FAQ Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'faqs_title'.tr,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        ...List.generate(controller.faqs.length, (index) {
                          final item = controller.faqs[index];
                          return Obx(() {
                            final isExpanded = controller.expandedFaqIndex.value == index;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  initiallyExpanded: isExpanded,
                                  onExpansionChanged: (_) => controller.toggleFaq(index),
                                  title: Text(
                                    item['q'] ?? '',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                      child: Text(
                                        item['a'] ?? '',
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        }),

                        const SizedBox(height: 24),

                        // Apple Mandatory Subscription Disclosures & Legal Links
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor.withOpacity(0.6)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subscription Information (Apple Terms)',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(() => Text(
                                '• Title: Velix Premium Monthly (${controller.displayPrice.value} / month)\n'
                                '• Length: 1 Month (Auto-Renewable)\n'
                                '• Payment: Charged to your Apple ID account at confirmation of purchase.\n'
                                '• Renewal: Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current billing cycle.\n'
                                '• Cancellation: You can manage or cancel your subscription anytime via your Apple ID Account Settings.',
                                style: TextStyle(
                                  color: labelColor,
                                  fontSize: 11,
                                  height: 1.45,
                                ),
                              )),
                              const SizedBox(height: 12),
                              Divider(color: borderColor, height: 1),
                              const SizedBox(height: 10),
                              // Legal Links Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showTermsDialog(context, cardColor, textColor, labelColor, primaryColor),
                                    child: const Text(
                                      'Terms of Use (EULA)',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('•', style: TextStyle(color: labelColor, fontSize: 12)),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showPrivacyDialog(context, cardColor, textColor, labelColor, primaryColor),
                                    child: const Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100), // padding for bottom floating action button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Fixed Purchase Button Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.92),
                border: Border(
                  top: BorderSide(color: borderColor),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  final isSubscribed = controller.isSubscribed.value;

                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (isLoading || isSubscribed) ? null : controller.subscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSubscribed ? const Color(0xFF00E676) : primaryColor,
                        disabledBackgroundColor: isSubscribed
                            ? const Color(0xFF00E676)
                            : primaryColor.withOpacity(0.6),
                        elevation: 6,
                        shadowColor: primaryColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isSubscribed ? Icons.check_circle : Icons.flash_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isSubscribed
                                      ? 'active_plan_cta'.tr
                                      : 'upgrade_now_cta'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context, Color cardColor, Color textColor, Color labelColor, Color primaryColor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Terms of Use (EULA)',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 380),
          child: SingleChildScrollView(
            child: Text(
              '1. Acceptance of Terms\n'
              'By subscribing to Velix Premium, you agree to comply with and be bound by these terms as well as Apple\'s standard Licensed Application End User License Agreement (EULA).\n\n'
              '2. Subscriptions & Billing\n'
              'Velix Premium is billed as an auto-renewable monthly subscription. Payment will be charged to your Apple ID account upon purchase confirmation.\n\n'
              '3. Automatic Renewal\n'
              'Subscriptions automatically renew unless auto-renewal is turned off at least 24 hours prior to the end of the current billing cycle.\n\n'
              '4. Cancellation & Refunds\n'
              'You can manage or cancel your subscription at any time via your Apple ID Account Settings. Refunds are handled exclusively by Apple according to App Store policies.\n\n'
              '5. Standard Apple EULA\n'
              'This application is governed by Apple\'s Standard EULA: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
              style: TextStyle(color: labelColor, fontSize: 13, height: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context, Color cardColor, Color textColor, Color labelColor, Color primaryColor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 380),
          child: SingleChildScrollView(
            child: Text(
              '1. Information We Collect\n'
              'Velix collects minimal user information strictly required to maintain your subscription state and account profile.\n\n'
              '2. In-App Purchase Data\n'
              'Payment processing is handled directly by Apple Inc. We do not store or process your credit card or financial credentials.\n\n'
              '3. Data Protection\n'
              'We do not sell, rent, or trade your personal data with third parties. All communication between your device and our servers is encrypted using industry-standard TLS/SSL.\n\n'
              '4. Contact Us\n'
              'For any privacy concerns, reach out to our team via Settings > Contact Support.',
              style: TextStyle(color: labelColor, fontSize: 13, height: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
