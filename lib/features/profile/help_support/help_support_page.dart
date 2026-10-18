import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D0E15) : const Color(0xFFF4F5F9);
    final cardColor = isDark ? const Color(0xFF141521) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF242536) : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF9482FF);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final iconBg = isDark ? const Color(0xFF1F2034) : const Color(0xFFF3F0FF);

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
          'help_support'.tr.isNotEmpty ? 'help_support'.tr : 'Help & Support',
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
              // Hero Support Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF252044), const Color(0xFF16152B)]
                        : [const Color(0xFFEDE9FE), const Color(0xFFF5F3FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('💬', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How can we help you?',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'We are here 24/7 to assist with your Velix account, subscriptions, or questions.',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contact Channels Section Header
              Text(
                'CONTACT US',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // Contact Channels Card
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildContactRow(
                      icon: Icons.email_outlined,
                      title: 'Email Support',
                      subtitle: 'support@velix.app',
                      primaryColor: primaryColor,
                      labelColor: labelColor,
                      textColor: textColor,
                      iconBg: iconBg,
                      onTap: () {
                        Get.snackbar(
                          'Support Email',
                          'Contact our team directly at support@velix.app',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 14,
                        );
                      },
                    ),
                    Divider(color: borderColor, height: 1),
                    _buildContactRow(
                      icon: Icons.smart_toy_outlined,
                      title: 'Ask AI Coach',
                      subtitle: 'Instant answers from your financial assistant',
                      primaryColor: primaryColor,
                      labelColor: labelColor,
                      textColor: textColor,
                      iconBg: iconBg,
                      onTap: () => Get.toNamed(Routes.aiCoach),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // FAQ Section Header
              Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // FAQ Accordion Card
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildFaqItem(
                      question: 'How does Velix track my subscriptions?',
                      answer: 'Velix monitors renewal dates, prices, and categories you enter and sends timely alerts before charges take place.',
                      textColor: textColor,
                      labelColor: labelColor,
                      borderColor: borderColor,
                    ),
                    Divider(color: borderColor, height: 1),
                    _buildFaqItem(
                      question: 'Is my financial data secure?',
                      answer: 'Yes! All personal and subscription data is stored securely adhering strictly to GDPR guidelines. We never sell your data.',
                      textColor: textColor,
                      labelColor: labelColor,
                      borderColor: borderColor,
                    ),
                    Divider(color: borderColor, height: 1),
                    _buildFaqItem(
                      question: 'How do I change my currency or language?',
                      answer: 'You can customize your language and notification preferences directly inside Profile > Settings.',
                      textColor: textColor,
                      labelColor: labelColor,
                      borderColor: borderColor,
                    ),
                    Divider(color: borderColor, height: 1),
                    _buildFaqItem(
                      question: 'Can I export my data?',
                      answer: 'Yes, in Settings > GDPR Data section, you can download all personal records with one tap.',
                      textColor: textColor,
                      labelColor: labelColor,
                      borderColor: borderColor,
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

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color labelColor,
    required Color textColor,
    required Color iconBg,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 22),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: labelColor, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required Color textColor,
    required Color labelColor,
    required Color borderColor,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: textColor,
        collapsedIconColor: labelColor,
        title: Text(
          question,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: labelColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
