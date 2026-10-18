import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordObscured = true.obs;
  final isRememberMe = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleRememberMe(bool? val) {
    isRememberMe.value = val ?? false;
  }

  void goToSignup() {
    Get.toNamed(Routes.signup);
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showSnackbar('Invalid Email', 'Please enter a valid email address', isError: true);
      return;
    }

    if (password.isEmpty) {
      _showSnackbar('Required Field', 'Please enter your password', isError: true);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData != null && responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;
          final token = (data['accessToken'] ?? data['token']) as String?;
          final user = data['user'] as Map<String, dynamic>?;

          if (token != null && Get.isRegistered<StorageService>()) {
            await Get.find<StorageService>().saveToken(token);
          }
          if (user != null && Get.isRegistered<StorageService>()) {
            await Get.find<StorageService>().saveUser(user);
          }

          if (Get.isRegistered<PushNotificationService>()) {
            final pushService = Get.find<PushNotificationService>();
            if (pushService.currentFcmToken == null || pushService.currentFcmToken!.isEmpty) {
              await pushService.setupFcmToken();
            } else {
              await pushService.syncTokenWithBackend();
            }
          }

          _showSnackbar(
            'Welcome Back 🎉',
            responseData['message'] ?? 'Logged in successfully',
            isError: false,
          );

          // Check isFinancialProfileCompleted flag for routing
          final bool isFinancialProfileCompleted = user?['isFinancialProfileCompleted'] == true;
          if (isFinancialProfileCompleted) {
            Get.offAllNamed(Routes.home);
          } else {
            Get.offAllNamed(Routes.questionnaire);
          }
          return;
        }

        Get.offAllNamed(Routes.home);
      } else {
        _showSnackbar(
          'Login Failed',
          responseData?['message'] ?? 'Invalid email or password',
          isError: true,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed. Please check your credentials and try again.';

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

      _showSnackbar('Login Error', errorMessage, isError: true);
    } catch (e) {
      _showSnackbar('Error', 'An unexpected error occurred: $e', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
