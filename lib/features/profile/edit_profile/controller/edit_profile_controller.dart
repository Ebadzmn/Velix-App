import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/controller/home_controller.dart';

class EditProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final firstNameController = TextEditingController();
  final surnameController = TextEditingController();
  final selectedCountry = 'Sweden'.obs;
  final avatarInitial = 'U'.obs;
  final profileImage = ''.obs;
  final selectedImage = Rxn<File>();
  final isLoading = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  final countries = ['Sweden', 'Norway', 'Denmark', 'Finland', 'UK', 'USA', 'Other'];

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  void _loadProfileData() {
    if (Get.isRegistered<StorageService>()) {
      final user = Get.find<StorageService>().getUser();
      if (user != null) {
        final first = user['firstName'] ?? '';
        final last = user['lastName'] ?? '';
        final country = user['country'] ?? 'Sweden';
        profileImage.value = user['profileImage']?.toString() ?? '';

        firstNameController.text = first;
        surnameController.text = last;
        selectedCountry.value = countries.contains(country) ? country : 'Sweden';

        if (first.isNotEmpty) {
          avatarInitial.value = first[0].toUpperCase();
        }
      }
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (image != null) selectedImage.value = File(image.path);
    } on PlatformException catch (e) {
      debugPrint('Profile image picker failed (${e.code}): ${e.message}');
      Get.snackbar(
        'Gallery unavailable',
        e.message?.isNotEmpty == true
            ? e.message!
            : 'Please check photo access in your device settings and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected profile image picker error: $e\n$stackTrace');
      Get.snackbar(
        'Gallery unavailable',
        'Could not open photos. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> saveChanges() async {
    final first = firstNameController.text.trim();
    final sur = surnameController.text.trim();
    final country = selectedCountry.value.trim();

    if (first.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your first name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;

    try {
      final formData = FormData.fromMap({
        'firstName': first,
        'lastName': sur,
        'country': country,
        if (selectedImage.value != null)
          'profileImage': await MultipartFile.fromFile(
            selectedImage.value!.path,
            filename: selectedImage.value!.uri.pathSegments.last,
          ),
      });
      final response = await _apiClient.patch(
        ApiEndpoints.profileMe,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final updatedData = response.data?['data'];
        if (updatedData != null && Get.isRegistered<StorageService>()) {
          await Get.find<StorageService>().saveUser(updatedData);
        }
        if (updatedData != null) {
          profileImage.value = updatedData['profileImage']?.toString() ?? '';
          selectedImage.value = null;
        }

        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.userFullName.value = '$first $sur'.trim();
          homeController.userProfileImage.value = profileImage.value;
          homeController.fetchHomeDashboard();
          homeController.fetchBudgetDashboard();
          homeController.fetchSubscriptionDashboard();
          homeController.fetchVariableCostsDashboard();
        }

        if (first.isNotEmpty) {
          avatarInitial.value = first[0].toUpperCase();
        }

        Get.back();
        Get.snackbar(
          'Success 🎉',
          response.data?['message'] ?? 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    } on DioException catch (e) {
      String msg = 'Could not update profile';
      if (e.response?.data != null && e.response!.data is Map) {
        msg = e.response!.data['message'] ?? msg;
      }
      Get.snackbar(
        'Error',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    surnameController.dispose();
    super.onClose();
  }
}
