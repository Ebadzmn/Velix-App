import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class SignupController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final isPasswordObscured = true.obs;
  final isConfirmPasswordObscured = true.obs;
  final isLoading = false.obs;

  final selectedCountry = 'Sweden'.obs;
  final selectedCurrency = 'KR'.obs;

  final countries = ['Sweden', 'Norway', 'Denmark', 'Finland', 'UK', 'USA', 'Other'];
  final currencies = ['KR', 'SEK', 'NOK', 'DKK', 'EUR', 'GBP', 'USD'];

  // Optional Tasks Accordion State
  final isOptionalTasksExpanded = false.obs;

  // Consent Checkboxes
  final isTermsAccepted = false.obs;
  final isAnalyticsAllowed = false.obs;

  // Password Validations
  final hasAtLeast8Chars = false.obs;
  final hasCapitalLetter = false.obs;
  final hasFigure = false.obs;

  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final text = passwordController.text;
    hasAtLeast8Chars.value = text.length >= 8;
    hasCapitalLetter.value = text.contains(RegExp(r'[A-Z]'));
    hasFigure.value = text.contains(RegExp(r'[0-9]'));
  }

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured.value = !isConfirmPasswordObscured.value;
  }

  void selectCountry(String country) {
    selectedCountry.value = country;
  }

  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  void toggleOptionalTasks() {
    isOptionalTasksExpanded.value = !isOptionalTasksExpanded.value;
  }

  void toggleTermsAcceptance(bool? val) {
    isTermsAccepted.value = val ?? false;
  }

  void toggleAnalyticsAllowed(bool? val) {
    isAnalyticsAllowed.value = val ?? false;
  }

  void goToLogin() {
    Get.toNamed(Routes.login);
  }

  Future<void> signup() async {
    final firstName = firstNameController.text.trim();
    final lastName = surnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final phone = phoneController.text.trim();

    // Client-side validations
    if (firstName.isEmpty) {
      _showSnackbar('Required Field', 'Please enter your first name', isError: true);
      return;
    }

    if (lastName.isEmpty) {
      _showSnackbar('Required Field', 'Please enter your last name / surname', isError: true);
      return;
    }

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showSnackbar('Invalid Email', 'Please enter a valid email address', isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackbar('Weak Password', 'Password must be at least 6 characters long', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar('Password Mismatch', 'Password and Confirm Password do not match', isError: true);
      return;
    }

    if (!isTermsAccepted.value) {
      _showSnackbar('Terms & Conditions', 'Please accept the Terms of Service to continue', isError: true);
      return;
    }

    isLoading.value = true;

    try {
      final requestBody = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        if (phone.isNotEmpty) 'phoneNumber': phone,
        if (selectedCountry.value.isNotEmpty) 'country': selectedCountry.value,
        if (selectedCurrency.value.isNotEmpty) 'currency': selectedCurrency.value,
        'role': 'USER',
      };

      final response = await _apiClient.post(
        ApiEndpoints.signup,
        data: requestBody,
      );

      final responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract token and user data
        if (responseData != null && responseData['data'] != null) {
          final token = responseData['data']['token'] as String?;
          final user = responseData['data']['user'] as Map<String, dynamic>?;

          if (token != null && Get.isRegistered<StorageService>()) {
            Get.find<StorageService>().saveToken(token);
          }
          if (user != null && Get.isRegistered<StorageService>()) {
            Get.find<StorageService>().saveUser(user);
          }

          if (Get.isRegistered<PushNotificationService>()) {
            final pushService = Get.find<PushNotificationService>();
            if (pushService.currentFcmToken == null || pushService.currentFcmToken!.isEmpty) {
              await pushService.setupFcmToken();
            } else {
              await pushService.syncTokenWithBackend();
            }
          }
        }

        _showSnackbar(
          'Success 🎉',
          responseData?['message'] ?? 'User registered successfully',
          isError: false,
        );

        // Navigate to next onboarding step
        Get.offAllNamed(Routes.questionnaire);
      } else {
        _showSnackbar(
          'Registration Failed',
          responseData?['message'] ?? 'Could not create account. Please try again.',
          isError: true,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Registration failed. Please check your connection and try again.';

      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic>) {
          if (errorData['errorMessages'] != null && errorData['errorMessages'] is List && (errorData['errorMessages'] as List).isNotEmpty) {
            errorMessage = errorData['errorMessages'][0]['message'] ?? errorData['message'] ?? errorMessage;
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        }
      }

      _showSnackbar('Registration Error', errorMessage, isError: true);
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
    firstNameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
