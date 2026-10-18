import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/push_notification_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  @override
  void onReady() {
    super.onReady();
    _startSplashTimer();
  }

  void _startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 2));

    if (Get.isRegistered<StorageService>()) {
      final storageService = Get.find<StorageService>();

      if (storageService.isLoggedIn) {
        // Fetch latest profile to check isFinancialProfileCompleted flag reliably
        try {
          final response = await _apiClient.get(ApiEndpoints.profileMe);
          if (response.statusCode == 200 && response.data != null) {
            final userData = response.data['data'];
            if (userData != null) {
              await storageService.saveUser(userData);
            }
          }
        } catch (_) {
          // If offline, rely on cached storage
        }

        // Sync device FCM push token with backend on startup
        if (Get.isRegistered<PushNotificationService>()) {
          Get.find<PushNotificationService>().syncTokenWithBackend();
        }

        // Check if questionnaire / financial profile is completed
        if (storageService.isFinancialProfileCompleted) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.offAllNamed(Routes.questionnaire);
        }
        return;
      }
    }

    // Otherwise navigate to onboarding
    Get.offAllNamed(Routes.onboarding);
  }
}
