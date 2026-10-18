import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_constants.dart';
import '../controller/edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0D0E15) : const Color(0xFFF4F5F9);
    final cardColor = isDark ? const Color(0xFF141521) : const Color(0xFFFFFFFF);
    final borderColor = isDark ? const Color(0xFF242536) : const Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF9482FF);
    final labelColor = isDark ? const Color(0xFF9EA3B0) : const Color(0xFF6B7280);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final avatarBg = isDark ? const Color(0xFF1F2034) : const Color(0xFFEDE9FE);

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
          'Edit profile',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(() {
                  final selected = controller.selectedImage.value;
                  final imageUrl = controller.profileImage.value;
                  ImageProvider? imageProvider;
                  if (selected != null) {
                    imageProvider = FileImage(selected);
                  } else if (imageUrl.isNotEmpty) {
                    final uri = Uri.tryParse(imageUrl);
                    final resolvedUrl = uri?.hasScheme == true
                        ? imageUrl
                        : '${AppConstants.baseUrl}$imageUrl';
                    imageProvider = NetworkImage(resolvedUrl);
                  }

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: avatarBg,
                        backgroundImage: imageProvider,
                        child: imageProvider == null
                            ? Text(
                                controller.avatarInitial.value,
                                style: TextStyle(
                                  color: isDark ? Colors.white : primaryColor,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Material(
                          color: primaryColor,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: controller.pickProfileImage,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 32),

              // First name Input Field
              Text(
                'First name',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: controller.firstNameController,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Surname Input Field
              Text(
                'Surname',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: controller.surnameController,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Country Dropdown Field
              Text(
                'Country',
                style: TextStyle(
                  color: labelColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.countries.contains(controller.selectedCountry.value)
                          ? controller.selectedCountry.value
                          : controller.countries.first,
                      isExpanded: true,
                      dropdownColor: cardColor,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: labelColor),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (String? newVal) {
                        if (newVal != null) {
                          controller.selectedCountry.value = newVal;
                        }
                      },
                      items: controller.countries.map((String c) {
                        return DropdownMenuItem<String>(
                          value: c,
                          child: Text(c),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 12),

              // Save changes Primary Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9482FF)),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: controller.saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Save changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 28),

              // Footer Info Text
              Center(
                child: Text(
                  'Your name is only visible to you and is stored securely.',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
