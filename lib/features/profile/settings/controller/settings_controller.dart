import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  late final ThemeController _themeController;

  final isLoadingLogout = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ThemeController>()) {
      _themeController = Get.find<ThemeController>();
    } else {
      _themeController = Get.put(ThemeController());
    }
    fetchNotificationSettings();
  }

  RxInt get selectedThemeIndex => _themeController.selectedThemeIndex;

  final renewalReminders = true.obs;
  final priceIncreases = true.obs;
  final unusedSubscriptions = true.obs;
  final budgetAlerts = false.obs;
  final savingsReminders = false.obs;
  final weeklyReport = false.obs;
  final monthlyReport = false.obs;
  final isLoadingNotificationSettings = false.obs;

  Future<void> fetchNotificationSettings() async {
    isLoadingNotificationSettings.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.notificationSettings);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          if (data['renewalReminders'] != null) renewalReminders.value = data['renewalReminders'] == true;
          if (data['priceIncreases'] != null) priceIncreases.value = data['priceIncreases'] == true;
          if (data['unusedSubscriptions'] != null) unusedSubscriptions.value = data['unusedSubscriptions'] == true;
          if (data['budgetAlerts'] != null) budgetAlerts.value = data['budgetAlerts'] == true;
          if (data['savingsReminders'] != null) savingsReminders.value = data['savingsReminders'] == true;
          if (data['weeklyReport'] != null) weeklyReport.value = data['weeklyReport'] == true;
          if (data['monthlyReport'] != null) monthlyReport.value = data['monthlyReport'] == true;
        }
      }
    } catch (_) {
      // Keep defaults
    } finally {
      isLoadingNotificationSettings.value = false;
    }
  }

  Future<void> updateNotificationSetting(String key, bool value) async {
    final setting = _notificationSettingForKey(key);
    if (setting == null) return;
    final previousValue = setting.value;
    setting.value = value;
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.notificationSettings,
        data: {key: value},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw StateError('Notification preference was not saved');
      }
    } catch (_) {
      setting.value = previousValue;
      Get.snackbar(
        'Could not save setting',
        'Check your connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  RxBool? _notificationSettingForKey(String key) {
    switch (key) {
      case 'renewalReminders':
        return renewalReminders;
      case 'priceIncreases':
        return priceIncreases;
      case 'unusedSubscriptions':
        return unusedSubscriptions;
      case 'budgetAlerts':
        return budgetAlerts;
      case 'savingsReminders':
        return savingsReminders;
      case 'weeklyReport':
        return weeklyReport;
      case 'monthlyReport':
        return monthlyReport;
      default:
        return null;
    }
  }

  void setThemeIndex(int index) {
    _themeController.setThemeIndex(index);
  }

  Future<void> logout() async {
    isLoadingLogout.value = true;
    try {
      // 1. Call Backend Logout Endpoint
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {
      // Continue client logout even if network fails
    } finally {
      // 2. Clear Local Storage Session
      if (Get.isRegistered<StorageService>()) {
        await Get.find<StorageService>().clearAuth();
      }

      isLoadingLogout.value = false;

      // 3. Navigate to Login Screen and clear navigation stack
      Get.offAllNamed(Routes.login);

      // 4. Feedback Snackbar
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9482FF),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF181926) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final borderColor = isDark ? const Color(0xFF242536) : const Color(0xFFE5E7EB);
    const redColor = Color(0xFFFF453A);

    Get.dialog(
      Dialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C141E) : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: redColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'log_out'.tr,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr.isNotEmpty ? 'cancel'.tr : 'Cancel',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: isLoadingLogout.value
                            ? null
                            : () {
                                Get.back();
                                logout();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoadingLogout.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'log_out'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
