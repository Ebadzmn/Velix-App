import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'privacy_policy'.tr.isNotEmpty ? 'privacy_policy'.tr : 'Privacy Policy',
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
              // Header Summary Card
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shield_outlined, color: primaryColor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Velix Privacy & Security',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Last updated: October 2026',
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
                    const SizedBox(height: 14),
                    Text(
                      'Your privacy is fundamentally important to us. Velix is committed to protecting your personal information and ensuring transparency in all our data practices in full compliance with GDPR.',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section 1: Information We Collect
              _buildSectionCard(
                icon: Icons.data_usage_outlined,
                title: '1. Information We Collect',
                content:
                    '• Account details: Name, email address, profile picture and preferences.\n'
                    '• Subscription data: Services, amounts, renewal cycles, and reminders you save.\n'
                    '• Device info: Operating system, app version, language, and push notification tokens for timely alerts.',
                textColor: textColor,
                labelColor: labelColor,
                cardColor: cardColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 16),

              // Section 2: How We Use Your Data
              _buildSectionCard(
                icon: Icons.lightbulb_outline,
                title: '2. How We Use Your Data',
                content:
                    '• Calculate renewal schedules and send push reminders before you get charged.\n'
                    '• Provide personalized AI financial tips and monthly cost summaries.\n'
                    '• Secure your account and authenticate login sessions reliably.',
                textColor: textColor,
                labelColor: labelColor,
                cardColor: cardColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 16),

              // Section 3: Data Protection & Security
              _buildSectionCard(
                icon: Icons.lock_outline,
                title: '3. Data Security & GDPR Rights',
                content:
                    '• High-standard TLS/SSL encryption for all data in transit and rest.\n'
                    '• Under GDPR, you have full rights to access, download, or delete all personal data at any time.\n'
                    '• We NEVER sell or broker your personal information to third parties or advertisers.',
                textColor: textColor,
                labelColor: labelColor,
                cardColor: cardColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 16),

              // Section 4: Contact & Data Deletion
              _buildSectionCard(
                icon: Icons.mail_outline,
                title: '4. Questions & Privacy Requests',
                content:
                    'To request data export or permanent deletion, you can use the in-app GDPR tools in Settings or email our Data Protection Officer at privacy@velix.app.',
                textColor: textColor,
                labelColor: labelColor,
                cardColor: cardColor,
                borderColor: borderColor,
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
    required Color textColor,
    required Color labelColor,
    required Color cardColor,
    required Color borderColor,
    required Color primaryColor,
  }) {
    return Container(
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
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
