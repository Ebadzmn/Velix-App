import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/network/api_client.dart';
import 'package:abbe_hossain/core/network/api_endpoints.dart';
import 'package:abbe_hossain/core/services/storage_service.dart';
import 'package:abbe_hossain/features/home/controller/home_controller.dart';

class AddCostController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final amountController = TextEditingController(text: '0');
  final itemController = TextEditingController();
  final selectedCategory = 'Food'.obs;
  late final TextEditingController dateController;
  final noteController = TextEditingController();
  final currency = 'KR'.obs;
  final isLoading = false.obs;

  final categories = [
    'Food',
    'Takeaway',
    'Shopping',
    'Transport',
    'The fun',
    'Health',
    'Household',
    'Swish',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.isRegistered<StorageService>()) {
        currency.value = Get.find<StorageService>().getUserCurrency();
      }
    } catch (_) {}
    final now = DateTime.now();
    final initialDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    dateController = TextEditingController(text: initialDate);
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
  }

  Future<void> saveCost() async {
    final amountStr = amountController.text.trim();
    final item = itemController.text.trim();
    final dateStr = dateController.text.trim();
    final noteStr = noteController.text.trim();

    if (item.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter what you bought (e.g. ICA, Subway ticket).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF3B30),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
      return;
    }

    final amountNum = double.tryParse(amountStr) ?? 0.0;
    if (amountNum <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid amount greater than 0.',
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
        'title': item,
        'amount': amountNum,
        'category': selectedCategory.value,
        if (dateStr.isNotEmpty) 'date': dateStr,
        if (noteStr.isNotEmpty) 'note': noteStr,
        'currency': currency.value,
      };

      final response = await _apiClient.post(
        ApiEndpoints.variableCosts,
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchVariableCostsDashboard();
        }

        Get.back();
        Get.snackbar(
          'Success 🎉',
          response.data?['message'] ?? '$item added to variable costs',
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
          response.data?['message'] ?? 'Cost saved',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF9482FF),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        Get.back();
      }
    } on DioException catch (e) {
      String errorMessage = 'Could not save variable cost. Please try again.';

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
    amountController.dispose();
    itemController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
