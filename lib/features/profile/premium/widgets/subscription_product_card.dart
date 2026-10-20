import 'package:flutter/material.dart';

/// Subscription Product Card conforming to Apple App Store Guideline 3.1.2(c).
/// Clearly displays:
/// - Subscription Name / Title
/// - Subscription Duration (e.g. 1 Month Auto-Renewable)
/// - Localized Subscription Price from StoreKit / IAP
/// - Auto-renewal disclosure note
class SubscriptionProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String billingPeriod;
  final String durationText;
  final String? badgeText;
  final String? renewalNote;
  final bool isSelected;
  final VoidCallback? onTap;

  const SubscriptionProductCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.billingPeriod = '/ month',
    this.durationText = '1 Month (Auto-Renewable)',
    this.badgeText,
    this.renewalNote,
    this.isSelected = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF9482FF);
    final borderColor = isDark ? const Color(0xFF24273E) : const Color(0xFFE5E7EB);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
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
            color: isSelected ? primaryColor.withValues(alpha: 0.8) : borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isDark ? 0.22 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Title, Duration Badge & Popular Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.bolt, color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            // Explicit Duration Label (Apple Guideline 3.1.2(c))
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                durationText,
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeText != null && badgeText!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9482FF), Color(0xFF7A65FF)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText!,
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

            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 16),

            // Price & Billing Period Row (Uses StoreKit localized price)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  billingPeriod,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Auto-renewal Notice
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFF00E676), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    renewalNote ?? 'Renews automatically · Cancel anytime in Settings',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF00E676) : const Color(0xFF059669),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
}
