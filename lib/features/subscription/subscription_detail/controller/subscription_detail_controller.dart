import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/network/api_client.dart';
import 'package:abbe_hossain/core/network/api_endpoints.dart';
import 'package:abbe_hossain/features/home/controller/home_controller.dart';
import 'package:abbe_hossain/features/subscription/models/subscription_model.dart';

class SubscriptionDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final name = ''.obs;
  final priceText = ''.obs;
  final category = 'Entertainment'.obs;
  final nextPayment = ''.obs;
  final annualCost = ''.obs;
  final icon = Icons.movie_outlined.obs;
  final iconColor = const Color(0xFFFF3B30).obs;
  final bgColor = const Color(0xFF2C141E).obs;
  final subscriptionId = ''.obs;
  final isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is SubscriptionItemModel) {
      subscriptionId.value = args.id;
      name.value = args.name;
      priceText.value = '${args.formattedPrice} / ${args.billingPeriod == 'yearly' ? 'year' : 'month'}';
      category.value = args.category;
      icon.value = args.icon;
      iconColor.value = args.iconColor;
      bgColor.value = args.bgColor;

      final annual = args.calculatedAnnualCost;
      final formattedAnnual = annual % 1 == 0 ? annual.toInt().toString() : annual.toStringAsFixed(1);
      annualCost.value = '${formattedAnnual.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} ${args.currency}';
      nextPayment.value = args.formattedDate;
    }
  }

  void cancelSubscription() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF141521),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cancel ${name.value}?',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete and remove this subscription from your account?',
          style: TextStyle(color: Color(0xFF9EA3B0)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!isDeleting.value) {
                Get.back();
              }
            },
            child: const Text('No, Keep It', style: TextStyle(color: Color(0xFF9EA3B0))),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: isDeleting.value ? null : _executeDeleteSubscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isDeleting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Cancel Subscription', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _executeDeleteSubscription() async {
    isDeleting.value = true;

    try {
      if (subscriptionId.value.isNotEmpty) {
        final endpoint = '${ApiEndpoints.subscriptions}/${subscriptionId.value}';
        final response = await _apiClient.delete(endpoint);

        if (response.statusCode == 200 || response.statusCode == 204) {
          if (Get.isRegistered<HomeController>()) {
            final home = Get.find<HomeController>();
            home.fetchSubscriptionDashboard();
          }

          Get.back(); // close dialog
          Get.back(); // return to previous screen
          Get.snackbar(
            'Success',
            response.data?['message'] ?? '${name.value} subscription removed successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF10B981),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 16,
            duration: const Duration(seconds: 3),
          );
          return;
        }
      }

      // Fallback local remove if id was not found
      if (Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        home.subscriptions.removeWhere((sub) => sub.id == subscriptionId.value || sub.name == name.value);
        home.fetchSubscriptionDashboard();
      }

      Get.back(); // close dialog
      Get.back(); // return to previous screen
      Get.snackbar(
        'Subscription Removed',
        '${name.value} has been removed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9482FF),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    } on DioException catch (e) {
      String errorMessage = 'Could not cancel subscription. Please try again.';

      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          if (errorData['errorMessages'] != null &&
              errorData['errorMessages'] is List &&
              (errorData['errorMessages'] as List).isNotEmpty) {
            errorMessage = errorData['errorMessages'][0]['message'] ??
                errorData['message'] ??
                errorMessage;
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    } finally {
      isDeleting.value = false;
    }
  }
}
