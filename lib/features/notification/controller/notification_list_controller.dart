import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abbe_hossain/core/network/api_client.dart';
import 'package:abbe_hossain/core/network/api_endpoints.dart';
import '../models/notification_model.dart';

class NotificationListController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;
  final notifications = <NotificationItemModel>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.notifications);
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data['data'];
        final meta = response.data['meta'];

        if (meta != null && meta['unreadCount'] != null) {
          unreadCount.value = (meta['unreadCount'] as num).toInt();
        }

        if (data is List) {
          notifications.value = data.map((e) => NotificationItemModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
      // Fallback empty list
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1 && !notifications[index].isRead) {
        final item = notifications[index];
        notifications[index] = NotificationItemModel(
          id: item.id,
          title: item.title,
          message: item.message,
          type: item.type,
          isRead: true,
          createdAt: item.createdAt,
          data: item.data,
        );
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
      }
      await _apiClient.patch('${ApiEndpoints.notifications}/$id/read');
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      notifications.value = notifications.map((item) {
        return NotificationItemModel(
          id: item.id,
          title: item.title,
          message: item.message,
          type: item.type,
          isRead: true,
          createdAt: item.createdAt,
          data: item.data,
        );
      }).toList();
      unreadCount.value = 0;
      await _apiClient.patch(ApiEndpoints.notificationMarkAllRead);
    } catch (_) {}
  }

  Future<void> deleteNotification(String id) async {
    try {
      final item = notifications.firstWhereOrNull((n) => n.id == id);
      if (item != null && !item.isRead && unreadCount.value > 0) {
        unreadCount.value--;
      }
      notifications.removeWhere((n) => n.id == id);
      await _apiClient.delete('${ApiEndpoints.notifications}/$id');
    } catch (_) {}
  }

  Future<void> sendTestPush() async {
    try {
      final response = await _apiClient.post('${ApiEndpoints.notifications}/test-push');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Push Sent! 🔔',
          'A test push notification has been dispatched to your device.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF1E1F30),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        await fetchNotifications();
      }
    } catch (e) {
      Get.snackbar(
        'Test Failed',
        'Could not trigger test push. Make sure device token is registered.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }
}
