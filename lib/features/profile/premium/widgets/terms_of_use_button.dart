import 'package:flutter/material.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/url_launcher_helper.dart';

/// Reusable Terms of Use (EULA) button conforming to Apple Guideline 3.1.2(c).
/// Tapping this button opens the configured Terms of Use URL in the user's browser.
/// If launching fails (e.g. offline/simulator), it displays an informative modal fallback.
class TermsOfUseButton extends StatelessWidget {
  final TextStyle? style;
  final VoidCallback? onFallback;

  const TermsOfUseButton({
    super.key,
    this.style,
    this.onFallback,
  });

  Future<void> _handleTap(BuildContext context) async {
    final success = await UrlLauncherHelper.launchWebUrl(AppConstants.termsOfUseUrl);
    if (!success) {
      if (onFallback != null) {
        onFallback!();
      } else if (context.mounted) {
        _showFallbackDialog(context);
      }
    }
  }

  void _showFallbackDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF141522) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    const primaryColor = Color(0xFF9482FF);

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
              'Velix Premium is billed as an auto-renewable monthly subscription. Payment is charged to your Apple ID account upon purchase confirmation.\n\n'
              '3. Automatic Renewal\n'
              'Subscriptions automatically renew unless auto-renewal is turned off at least 24 hours prior to the end of the current billing cycle.\n\n'
              '4. Cancellation & Refunds\n'
              'You can manage or cancel your subscription at any time via your Apple ID Account Settings. Refunds are handled exclusively by Apple.\n\n'
              '5. Standard Apple EULA\n'
              'This application is governed by Apple\'s Standard EULA: ${AppConstants.appleStandardEulaUrl}',
              style: TextStyle(color: labelColor, fontSize: 13, height: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const defaultColor = Color(0xFF9482FF);
    final textStyle = style ??
        const TextStyle(
          color: defaultColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        );

    return InkWell(
      key: const Key('subscription_terms_of_use_button'),
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          'Terms of Use (EULA)',
          style: textStyle,
        ),
      ),
    );
  }
}
