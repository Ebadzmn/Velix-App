import 'package:flutter/material.dart';
import 'privacy_policy_button.dart';
import 'terms_of_use_button.dart';

/// Reusable legal links row conforming to Apple Guideline 3.1.2(c).
/// Prominently displays functional links to Terms of Use (EULA) and Privacy Policy.
class LegalLinks extends StatelessWidget {
  final MainAxisAlignment alignment;
  final TextStyle? textStyle;
  final Color? dotColor;
  final VoidCallback? onTermsFallback;
  final VoidCallback? onPrivacyFallback;

  const LegalLinks({
    super.key,
    this.alignment = MainAxisAlignment.center,
    this.textStyle,
    this.dotColor,
    this.onTermsFallback,
    this.onPrivacyFallback,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final separatorColor = dotColor ?? (isDark ? const Color(0xFF6B7280) : const Color(0xFF9EA3B0));

    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        TermsOfUseButton(
          style: textStyle,
          onFallback: onTermsFallback,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '•',
            style: TextStyle(
              color: separatorColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PrivacyPolicyButton(
          style: textStyle,
          onFallback: onPrivacyFallback,
        ),
      ],
    );
  }
}
