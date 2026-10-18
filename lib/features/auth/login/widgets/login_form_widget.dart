import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../controller/login_controller.dart';

class LoginFormWidget extends GetView<LoginController> {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: controller.emailController,
          hintText: 'Email',
          prefixIcon: const Icon(Icons.email),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.passwordController,
          hintText: 'Password',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock),
        ),
        const SizedBox(height: 24),
        Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator()
            : CustomButton(
                label: 'Login',
                onPressed: controller.login,
              )),
      ],
    );
  }
}
