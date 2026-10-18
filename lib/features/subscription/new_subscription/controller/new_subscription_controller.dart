import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/network/api_client.dart';
import 'package:abbe_hossain/core/network/api_endpoints.dart';
import 'package:abbe_hossain/core/services/storage_service.dart';
import 'package:abbe_hossain/features/home/controller/home_controller.dart';

class NewSubscriptionController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final nameController = TextEditingController();
  final priceController = TextEditingController(text: '149');
  final selectedCategory = 'Entertainment'.obs;
  final billingPeriod = 'monthly'.obs; // "monthly" or "yearly"
  final currency = 'KR'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.isRegistered<StorageService>()) {
        currency.value = Get.find<StorageService>().getUserCurrency();
      }
    } catch (_) {}
  }

  final categories = [
    {'name': 'Entertainment', 'icon': Icons.movie_filter_outlined, 'color': const Color(0xFFE50914)},
    {'name': 'Music', 'icon': Icons.music_note_outlined, 'color': const Color(0xFF00E676)},
    {'name': 'Streaming', 'icon': Icons.tv_outlined, 'color': const Color(0xFF0A84FF)},
    {'name': 'Software', 'icon': Icons.code, 'color': const Color(0xFF9482FF)},
    {'name': 'Training', 'icon': Icons.fitness_center, 'color': const Color(0xFFFF5252)},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_outlined, 'color': const Color(0xFF00BCD4)},
    {'name': 'Productivity', 'icon': Icons.work_outline, 'color': const Color(0xFF10B981)},
    {'name': 'Other', 'icon': Icons.credit_card_outlined, 'color': const Color(0xFF9EA3B0)},
  ];

  final popularServices = [
    {
      'name': 'Netflix',
      'price': '149',
      'subtitle': '149 /month',
      'icon': Icons.movie_outlined,
      'color': const Color(0xFFE50914),
      'category': 'Entertainment',
      'billing_period': 'monthly',
    },
    {
      'name': 'Spotify',
      'price': '119',
      'subtitle': '119 /month',
      'icon': Icons.music_note,
      'color': const Color(0xFF1DB954),
      'category': 'Music',
      'billing_period': 'monthly',
    },
    {
      'name': 'Disney+',
      'price': '89',
      'subtitle': '89 /month',
      'icon': Icons.auto_awesome,
      'color': const Color(0xFF0056D2),
      'category': 'Entertainment',
      'billing_period': 'monthly',
    },
    {
      'name': 'YouTube Premium',
      'price': '129',
      'subtitle': '129 /month',
      'icon': Icons.play_arrow_rounded,
      'color': const Color(0xFFFF0000),
      'category': 'Entertainment',
      'billing_period': 'monthly',
    },
    {
      'name': 'Microsoft 365',
      'price': '89',
      'subtitle': '89 /month',
      'icon': Icons.grid_view_rounded,
      'color': const Color(0xFF9482FF),
      'category': 'Software',
      'billing_period': 'monthly',
    },
  ];

  void selectPopularService(Map<String, dynamic> service) {
    nameController.text = service['name'] as String;
    priceController.text = service['price'] as String;
    selectedCategory.value = service['category'] as String;
    billingPeriod.value = (service['billing_period'] as String?) ?? 'monthly';
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
  }

  void setBillingPeriod(String period) {
    billingPeriod.value = period;
  }

  Future<void> saveSubscription() async {
    final name = nameController.text.trim();
    final priceStr = priceController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a subscription name.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF3B30),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    final priceNum = double.tryParse(priceStr) ?? 0.0;
    if (priceNum <= 0) {
      Get.snackbar(
        'Invalid Price',
        'Please enter a valid price greater than 0.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF3B30),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    isLoading.value = true;

    try {
      final payload = {
        'name': name,
        'price': priceNum,
        'billing_period': billingPeriod.value,
        'currency': currency.value,
        'category': selectedCategory.value,
      };

      final response = await _apiClient.post(
        ApiEndpoints.subscriptions,
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh dashboard in HomeController if active
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchSubscriptionDashboard();
        }

        Get.back();
        Get.snackbar(
          'Success 🎉',
          response.data?['message'] ?? '$name added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Notice',
          response.data?['message'] ?? 'Subscription added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF9482FF),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Get.back();
      }
    } on DioException catch (e) {
      String errorMessage = 'Could not add subscription. Please try again.';

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
        'Validation Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
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
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
