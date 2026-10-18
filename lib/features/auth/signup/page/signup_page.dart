import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/signup_controller.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0D0E15);
    const cardColor = Color(0xFF141521);
    const borderColor = Color(0xFF242536);
    const primaryColor = Color(0xFF9482FF);
    const linkColor = Color(0xFF8294FF);
    const labelColor = Color(0xFF9EA3B0);
    const sectionHeaderColor = Color(0xFF7A7D8D);
    const greenColor = Color(0xFF00E676);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Create account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ACCOUNT Section Header
            const Text(
              'ACCOUNT',
              style: TextStyle(
                color: sectionHeaderColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),

            // First Name & Surname Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'First name',
                    controller: controller.firstNameController,
                    hintText: 'DF',
                    cardColor: cardColor,
                    borderColor: borderColor,
                    labelColor: labelColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    label: 'Surname',
                    controller: controller.surnameController,
                    hintText: 'DR',
                    cardColor: cardColor,
                    borderColor: borderColor,
                    labelColor: labelColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email Address
            _buildInputField(
              label: 'Email address',
              controller: controller.emailController,
              hintText: 'ebaduzzamWanebad@gmail.com',
              prefixIcon: Icons.mail_outline,
              cardColor: cardColor,
              borderColor: borderColor,
              labelColor: labelColor,
            ),
            const SizedBox(height: 16),

            // Password
            Obx(
              () => _buildInputField(
                label: 'Password',
                controller: controller.passwordController,
                obscureText: controller.isPasswordObscured.value,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isPasswordObscured.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixPressed: controller.togglePasswordVisibility,
                cardColor: cardColor,
                borderColor: borderColor,
                labelColor: labelColor,
              ),
            ),
            const SizedBox(height: 12),

            // Password Strength Segment Bar
            Obx(() {
              final val1 = controller.hasAtLeast8Chars.value;
              final val2 = controller.hasCapitalLetter.value;
              final val3 = controller.hasFigure.value;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: val1 ? Colors.orangeAccent : const Color(0xFF262738),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: val2 ? Colors.orangeAccent : const Color(0xFF262738),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: val3 ? Colors.orangeAccent : const Color(0xFF262738),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Password Criteria Checklist
                  Row(
                    children: [
                      _buildCriteriaItem('At least 8 characters', val1, greenColor, labelColor),
                      const SizedBox(width: 12),
                      _buildCriteriaItem('Capital letter', val2, greenColor, labelColor),
                      const SizedBox(width: 12),
                      _buildCriteriaItem('Figure', val3, greenColor, labelColor),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),

            // Confirm Password
            Obx(
              () => _buildInputField(
                label: 'Confirm password',
                controller: controller.confirmPasswordController,
                obscureText: controller.isConfirmPasswordObscured.value,
                prefixIcon: Icons.lock_outline,
                suffixIcon: controller.isConfirmPasswordObscured.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                onSuffixPressed: controller.toggleConfirmPasswordVisibility,
                cardColor: cardColor,
                borderColor: borderColor,
                labelColor: labelColor,
              ),
            ),
            const SizedBox(height: 16),

            // Optional Tasks Accordion Card
            GestureDetector(
              onTap: controller.toggleOptionalTasks,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Optional tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(
                      () => Icon(
                        controller.isOptionalTasksExpanded.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Optional Tasks Expandable Content (Phone number, Country, Currency)
            Obx(
              () => controller.isOptionalTasksExpanded.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Number (optional)
                        _buildInputField(
                          label: 'Phone number (optional)',
                          controller: controller.phoneController,
                          hintText: '+46 70 123 45 67',
                          prefixIcon: Icons.phone_outlined,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          labelColor: labelColor,
                        ),
                        const SizedBox(height: 20),

                        // Country (optional)
                        const Text(
                          'Country (optional)',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.countries.map((country) {
                            final isSelected = controller.selectedCountry.value == country;
                            return ChoiceChip(
                              label: Text(country),
                              selected: isSelected,
                              onSelected: (_) => controller.selectCountry(country),
                              selectedColor: const Color(0xFF28293D),
                              backgroundColor: const Color(0xFF161724),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : labelColor,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? Colors.white38 : Colors.transparent,
                                ),
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Currency (optional)
                        const Text(
                          'Currency (optional)',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.currencies.map((currency) {
                            final isSelected = controller.selectedCurrency.value == currency;
                            return ChoiceChip(
                              label: Text(currency),
                              selected: isSelected,
                              onSelected: (_) => controller.selectCurrency(currency),
                              selectedColor: const Color(0xFF28293D),
                              backgroundColor: const Color(0xFF161724),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : labelColor,
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? Colors.white38 : Colors.transparent,
                                ),
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // CONSENT Section Header
            const Text(
              'CONSENT',
              style: TextStyle(
                color: sectionHeaderColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            // CONSENT Container Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                children: [
                  // Row 1: Terms of Use & Privacy Policy
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(unselectedWidgetColor: const Color(0xFF333446)),
                          child: Checkbox(
                            value: controller.isTermsAccepted.value,
                            onChanged: controller.toggleTermsAcceptance,
                            activeColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 14, height: 1.4),
                              children: [
                                const TextSpan(
                                  text: 'I accept ',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'the Terms of Use',
                                  style: const TextStyle(
                                    color: linkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                                const TextSpan(
                                  text: ' and ',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                    color: linkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {},
                                ),
                                const TextSpan(
                                  text: '\n(required)',
                                  style: TextStyle(color: labelColor, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: borderColor, height: 24),

                  // Row 2: Analytics Data Consent
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: ThemeData(unselectedWidgetColor: const Color(0xFF333446)),
                          child: Checkbox(
                            value: controller.isAnalyticsAllowed.value,
                            onChanged: controller.toggleAnalyticsAllowed,
                            activeColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Allow anonymous analytics data to improve the app (optional)',
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Create account Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(
                () {
                  final isEnabled = controller.isTermsAccepted.value;
                  return controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: controller.signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEnabled ? primaryColor : const Color(0xFF1E1F2E),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Create account',
                            style: TextStyle(
                              color: isEnabled ? Colors.white : Colors.white38,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Already have an account? Log in
            Center(
              child: GestureDetector(
                onTap: controller.goToLogin,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: labelColor),
                      ),
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper builder for input fields
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixPressed,
    required Color cardColor,
    required Color borderColor,
    required Color labelColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white60),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.white54, size: 20)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon, color: Colors.white54, size: 20),
                      onPressed: onSuffixPressed,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // Helper builder for password criteria check item
  Widget _buildCriteriaItem(String title, bool isSatisfied, Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isSatisfied ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isSatisfied ? activeColor : inactiveColor,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            color: isSatisfied ? activeColor : inactiveColor,
            fontSize: 12,
            fontWeight: isSatisfied ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
