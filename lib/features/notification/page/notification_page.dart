import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../controller/notification_list_controller.dart';
import '../models/notification_model.dart';

class NotificationPage extends GetView<NotificationListController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D0E15) : const Color(0xFFF4F5F9);
    final cardColor = isDark ? const Color(0xFF141521) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF242536) : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF9482FF);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    const redColor = Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'notifications'.tr,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send_to_mobile, color: primaryColor),
            tooltip: 'Send Test Push',
            onPressed: () => controller.sendTestPush(),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: textColor),
            tooltip: 'settings'.tr,
            onPressed: () => Get.toNamed(Routes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Action Bar (Unread count badge + Mark all as read)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final count = controller.unreadCount.value;
                    return Row(
                      children: [
                        Text(
                          'Recent updates',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count new',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: () => controller.markAllAsRead(),
                    child: Text(
                      'Mark all as read',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Notification List or Empty State
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.notifications.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: primaryColor));
                }

                if (controller.notifications.isEmpty) {
                  return RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () => controller.fetchNotifications(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E1F30) : const Color(0xFFEDE9FE),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.notifications_none_outlined, size: 38, color: primaryColor),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  'We\'ll notify you when renewal dates arrive, budgets update, or savings reach milestones.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () => controller.fetchNotifications(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = controller.notifications[index];
                      return _buildNotificationCard(
                        item: item,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        labelColor: labelColor,
                        primaryColor: primaryColor,
                        isDark: isDark,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required NotificationItemModel item,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color labelColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    final iconData = _getIconForType(item.type);
    final iconBg = _getBgColorForType(item.type, isDark);
    final iconColor = _getIconColorForType(item.type);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteNotification(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () {
          if (!item.isRead) {
            controller.markAsRead(item.id);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead ? cardColor : (isDark ? const Color(0xFF191B2B) : const Color(0xFFF7F6FE)),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.isRead ? borderColor : primaryColor.withOpacity(0.4),
              width: item.isRead ? 1.0 : 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    if (item.createdAt != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(item.createdAt!),
                        style: TextStyle(
                          color: labelColor.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'renewal':
        return Icons.event_repeat;
      case 'price_increase':
        return Icons.trending_up;
      case 'unused_sub':
        return Icons.visibility_off_outlined;
      case 'budget_alert':
        return Icons.error_outline;
      case 'savings_goal':
        return Icons.savings_outlined;
      case 'report':
        return Icons.bar_chart;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _getBgColorForType(String type, bool isDark) {
    switch (type) {
      case 'renewal':
        return isDark ? const Color(0xFF221E36) : const Color(0xFFEDE9FE);
      case 'price_increase':
      case 'budget_alert':
        return isDark ? const Color(0xFF2E1A1A) : const Color(0xFFFEE2E2);
      case 'savings_goal':
        return isDark ? const Color(0xFF132A23) : const Color(0xFFDCFCE7);
      case 'unused_sub':
      case 'report':
        return isDark ? const Color(0xFF2A2315) : const Color(0xFFFEF3C7);
      default:
        return isDark ? const Color(0xFF1E2034) : const Color(0xFFF3F4F6);
    }
  }

  Color _getIconColorForType(String type) {
    switch (type) {
      case 'renewal':
        return const Color(0xFF9482FF);
      case 'price_increase':
      case 'budget_alert':
        return const Color(0xFFFF3B30);
      case 'savings_goal':
        return const Color(0xFF00E676);
      case 'unused_sub':
      case 'report':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF9482FF);
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
