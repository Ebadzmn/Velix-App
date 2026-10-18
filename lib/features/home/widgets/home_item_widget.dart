import 'package:flutter/material.dart';

class HomeItemWidget extends StatelessWidget {
  final String title;

  const HomeItemWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.star),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
