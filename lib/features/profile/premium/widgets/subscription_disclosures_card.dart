import 'package:flutter/material.dart';
import 'legal_links.dart';

/// Apple Guideline 3.1.2(c) Mandatory Subscription Disclosure Card.
/// Provides all required subscription disclosures, auto-renewal terms,
/// and functional links to Terms of Use (EULA) and Privacy Policy.
class SubscriptionDisclosuresCard extends StatelessWidget {
  final String subscriptionTitle;
  final String subscriptionDuration;
  final String subscriptionPrice;
  final VoidCallback? onTermsFallback;
  final VoidCallback? onPrivacyFallback;

  const SubscriptionDisclosuresCard({
    super.key,
    required this.subscriptionTitle,
    required this.subscriptionDuration,
    required this.subscriptionPrice,
    this.onTermsFallback,
    this.onPrivacyFallback,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF141522) : Colors.white;
    final borderColor = isDark ? const Color(0xFF24273E) : const Color(0xFFE5E7EB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    const primaryColor = Color(0xFF9482FF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: isDark ? 0.6 : 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Subscription Information (Apple Terms)',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Explicit Subscription details mandated by Apple Guideline 3.1.2(c)
          _buildInfoRow('Subscription Title', subscriptionTitle, textColor, labelColor),
          const SizedBox(height: 4),
          _buildInfoRow('Subscription Duration', subscriptionDuration, textColor, labelColor),
          const SizedBox(height: 4),
          _buildInfoRow('Subscription Price', '$subscriptionPrice / month', textColor, labelColor),

          const SizedBox(height: 12),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 12),

          // Auto-renewal Terms & Cancellation
          Text(
            '• Payment will be charged to your Apple ID account at confirmation of purchase.\n'
            '• Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.\n'
            '• Your account will be charged for renewal within 24 hours prior to the end of the current period.\n'
            '• You can manage or cancel your subscription anytime via your Apple ID Account Settings.',
            style: TextStyle(
              color: labelColor,
              fontSize: 11,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'By subscribing, your subscription automatically renews unless canceled according to Apple\'s subscription terms.',
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),

          const SizedBox(height: 14),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 12),

          // Functional Legal Links (Terms of Use & Privacy Policy)
          Center(
            child: LegalLinks(
              onTermsFallback: onTermsFallback,
              onPrivacyFallback: onPrivacyFallback,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color textColor, Color labelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $label: ',
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
