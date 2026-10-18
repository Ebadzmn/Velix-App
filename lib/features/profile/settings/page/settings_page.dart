import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/localization/localization_controller.dart';
import '../../../../routes/app_routes.dart';
import '../controller/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

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
    final iconBg = isDark ? const Color(0xFF1F2034) : const Color(0xFFF3F0FF);

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
          'settings'.tr,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SUBSCRIPTION Section
              _buildSectionHeader('subscription_section'.tr, labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  _buildSettingRow(
                    icon: Icons.flash_on,
                    title: 'upgrade_to_premium'.tr,
                    subtitle: 'upgrade_to_premium_sub'.tr,
                    onTap: () => Get.toNamed(Routes.upgradePremium),
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSettingRow(
                    icon: Icons.menu_book_outlined,
                    title: 'premium_terms'.tr,
                    subtitle: 'premium_terms_sub'.tr,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // APPEARANCE Section
              _buildSectionHeader('appearance_section'.tr, labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  // Theme Row with Segmented Control
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: iconBg,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.nightlight_round, color: primaryColor, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'theme'.tr,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Theme Segmented Switch Pill
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161726) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: Obx(() {
                            final currentThemeIndex = controller.selectedThemeIndex.value;
                            return Row(
                              children: [
                                Expanded(child: _buildThemeSegment('theme_system'.tr, 0, currentThemeIndex, controller, isDark)),
                                const SizedBox(width: 4),
                                Expanded(child: _buildThemeSegment('theme_bright'.tr, 1, currentThemeIndex, controller, isDark)),
                                const SizedBox(width: 4),
                                Expanded(child: _buildThemeSegment('theme_dark'.tr, 2, currentThemeIndex, controller, isDark)),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: borderColor, height: 1),
                  Obx(() {
                    final locController = Get.find<LocalizationController>();
                    final lang = locController.currentLanguage;
                    return _buildSettingRow(
                      icon: Icons.language,
                      title: 'language'.tr,
                      subtitle: '${lang.flag} ${lang.name}',
                      onTap: () => locController.showLanguageSelector(context),
                      primaryColor: primaryColor,
                      labelColor: labelColor,
                      textColor: textColor,
                      iconBg: iconBg,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),

              // NOTIFICATIONS Section
              _buildSectionHeader('notifications'.tr.toUpperCase(), labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  _buildSwitchRow(
                    icon: Icons.notifications_none_outlined,
                    title: 'renewal_reminders'.tr,
                    subtitle: 'renewal_reminders_sub'.tr,
                    rxValue: controller.renewalReminders,
                    settingKey: 'renewalReminders',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSwitchRow(
                    icon: Icons.trending_up,
                    title: 'price_increases'.tr,
                    subtitle: 'price_increases_sub'.tr,
                    rxValue: controller.priceIncreases,
                    settingKey: 'priceIncreases',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSwitchRow(
                    icon: Icons.visibility_off_outlined,
                    title: 'unused_subs'.tr,
                    subtitle: 'unused_subs_sub'.tr,
                    rxValue: controller.unusedSubscriptions,
                    settingKey: 'unusedSubscriptions',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSwitchRow(
                    icon: Icons.error_outline,
                    title: 'budget_alerts'.tr,
                    subtitle: 'budget_alerts_sub'.tr,
                    rxValue: controller.budgetAlerts,
                    settingKey: 'budgetAlerts',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSwitchRow(
                    icon: Icons.track_changes,
                    title: 'savings_reminders'.tr,
                    subtitle: 'savings_reminders_sub'.tr,
                    rxValue: controller.savingsReminders,
                    settingKey: 'savingsReminders',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSwitchRow(
                    icon: Icons.bar_chart,
                    title: 'weekly_report'.tr,
                    subtitle: 'weekly_report_sub'.tr,
                    rxValue: controller.weeklyReport,
                    settingKey: 'weeklyReport',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSwitchRow(
                    icon: Icons.calendar_today_outlined,
                    title: 'monthly_report'.tr,
                    subtitle: 'monthly_report_sub'.tr,
                    rxValue: controller.monthlyReport,
                    settingKey: 'monthlyReport',
                    controller: controller,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // SECURITY Section
              _buildSectionHeader('security_section'.tr, labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  _buildSettingRow(
                    icon: Icons.lock_outline,
                    title: 'pin_code'.tr,
                    subtitle: 'pin_code_sub'.tr,
                    rightBadgeText: 'soon'.tr,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSettingRow(
                    icon: Icons.visibility_outlined,
                    title: 'biometric_login'.tr,
                    subtitle: 'biometric_login_sub'.tr,
                    rightBadgeText: 'soon'.tr,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ACCOUNT Section
              _buildSectionHeader('account_section'.tr, labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  _buildSettingRow(
                    icon: Icons.logout,
                    iconBgColor: isDark ? const Color(0xFF2C141E) : const Color(0xFFFEE2E2),
                    iconColor: redColor,
                    title: 'log_out'.tr,
                    titleColor: redColor,
                    subtitle: 'log_out_sub'.tr,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                    onTap: () => controller.showLogoutConfirmationDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // LEGAL & PRIVACY Section
              _buildSectionHeader('legal_privacy_section'.tr, labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  _buildSettingRow(
                    icon: Icons.shield_outlined,
                    title: 'privacy_policy'.tr,
                    subtitle: 'privacy_policy_sub'.tr,
                    onTap: () => Get.toNamed(Routes.privacyPolicy),
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSettingRow(
                    icon: Icons.description_outlined,
                    title: 'terms_of_use'.tr,
                    onTap: () => Get.toNamed(Routes.privacyPolicy),
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSettingRow(
                    icon: Icons.info_outline,
                    title: 'about_velix'.tr,
                    onTap: () => Get.toNamed(Routes.helpSupport),
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSettingRow(
                    icon: Icons.chat_bubble_outline,
                    title: 'contact_support'.tr,
                    onTap: () => Get.toNamed(Routes.helpSupport),
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // YOUR DATA (GDPR) Section
              _buildSectionHeader('your_data_section'.tr, labelColor),
              _buildCardGroup(
                borderColor: borderColor,
                cardColor: cardColor,
                children: [
                  _buildSettingRow(
                    icon: Icons.file_download_outlined,
                    title: 'download_my_data'.tr,
                    subtitle: 'download_my_data_sub'.tr,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                  Divider(color: borderColor, height: 1),
                  _buildSettingRow(
                    icon: Icons.delete_outline,
                    iconBgColor: isDark ? const Color(0xFF2C141E) : const Color(0xFFFEE2E2),
                    iconColor: redColor,
                    title: 'delete_account'.tr,
                    titleColor: redColor,
                    subtitle: 'delete_account_sub'.tr,
                    primaryColor: primaryColor,
                    labelColor: labelColor,
                    textColor: textColor,
                    iconBg: iconBg,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Information Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: labelColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'settings_info_title'.tr,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'settings_info_desc'.tr,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Velix Version Footer Text
              Center(
                child: Text(
                  'made_with_love'.tr,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Builder helper for section header titles
  Widget _buildSectionHeader(String title, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          color: labelColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Builder helper for rounded card container groups
  Widget _buildCardGroup({
    required List<Widget> children,
    required Color cardColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  // Builder helper for theme segment items
  Widget _buildThemeSegment(String title, int index, int currentIndex, SettingsController controller, bool isDark) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => controller.setThemeIndex(index),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E1F30) : const Color(0xFFFFFFFF))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? (isDark ? Colors.white : const Color(0xFF9482FF)) : const Color(0xFF8A8D9B),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Builder helper for normal setting option rows
  Widget _buildSettingRow({
    required IconData icon,
    Color? iconBgColor,
    Color? iconColor,
    required String title,
    Color? titleColor,
    String? subtitle,
    String? rightBadgeText,
    VoidCallback? onTap,
    required Color primaryColor,
    required Color labelColor,
    required Color textColor,
    required Color iconBg,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor ?? iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor ?? primaryColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: titleColor ?? textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null && subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (rightBadgeText != null && rightBadgeText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rightBadgeText,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              Icon(Icons.chevron_right, color: labelColor, size: 22),
          ],
        ),
      ),
    );
  }

  // Builder helper for switch setting rows
  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool rxValue,
    required String settingKey,
    required SettingsController controller,
    required Color primaryColor,
    required Color labelColor,
    required Color textColor,
    required Color iconBg,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => Switch.adaptive(
              value: rxValue.value,
              onChanged: (val) {
                controller.updateNotificationSetting(settingKey, val);
              },
              activeColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
