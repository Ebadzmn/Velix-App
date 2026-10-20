import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../routes/app_routes.dart';

/// Reusable Privacy Policy button conforming to Apple Guideline 3.1.2(c).
/// Tapping this button opens the configured Privacy Policy URL in the user's browser,
/// or smoothly falls back to the in-app Privacy Policy page.
class PrivacyPolicyButton extends StatelessWidget {
  final TextStyle? style;
  final VoidCallback? onFallback;

  const PrivacyPolicyButton({
    super.key,
    this.style,
    this.onFallback,
  });

  Future<void> _handleTap(BuildContext context) async {
    final success = await UrlLauncherHelper.launchWebUrl(AppConstants.privacyPolicyUrl);
    if (!success) {
      if (onFallback != null) {
        onFallback!();
      } else {
        // Fallback to in-app Privacy Policy page
        Get.toNamed(Routes.privacyPolicy);
      }
    }
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
      key: const Key('subscription_privacy_policy_button'),
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          'Privacy Policy',
          style: textStyle,
        ),
      ),
    );
  }
}
