import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Centralized URL launcher utility conforming to Apple App Store Review
/// and mobile URL handling requirements.
class UrlLauncherHelper {
  /// Launches an external or in-app web URL safely.
  /// Returns `true` if the URL was successfully launched, `false` otherwise.
  static Future<bool> launchWebUrl(
    String urlString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final trimmed = urlString.trim();
    if (trimmed.isEmpty) {
      debugPrint('[UrlLauncherHelper] Cannot launch empty URL');
      return false;
    }

    try {
      final Uri uri = Uri.parse(trimmed);
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        return await launchUrl(uri, mode: mode);
      } else {
        // Fallback: try launching directly without pre-check in case OS allows it
        return await launchUrl(uri, mode: mode);
      }
    } catch (e) {
      debugPrint('[UrlLauncherHelper] Failed to launch URL "$trimmed": $e');
      return false;
    }
  }
}
