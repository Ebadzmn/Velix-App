import 'package:flutter/material.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.g_mobiledata, size: 40),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.facebook, size: 30),
          onPressed: () {},
        ),
      ],
    );
  }
}
