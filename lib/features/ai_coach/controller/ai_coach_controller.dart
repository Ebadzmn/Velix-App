import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class AiCoachController extends GetxController {
  final messageInputController = TextEditingController();
  final scrollController = ScrollController();

  final quickPrompts = [
    'How can I save more this month?',
    'Analyze my subscriptions',
    'Am I overspending on food?',
    'How to reach my Holiday goal faster?',
  ];

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialWelcomeMessage();
  }

  void _loadInitialWelcomeMessage() {
    String name = 'there';
    int subCount = 3;
    int subTotal = 387;

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      name = home.userFullName.value.split(' ').first;
      subCount = home.subscriptions.length;
      subTotal = home.monthlySubscriptionTotal.value;
    }

    final nowStr = _getFormattedTime();

    messages.add(
      ChatMessage(
        text: 'Hello $name! 👋 I am your Velix AI Financial Coach. Based on your current data, you have $subCount active subscriptions costing $subTotal SEK/month.\n\nHow can I assist your financial health today?',
        isUser: false,
        time: nowStr,
      ),
    );
  }

  void sendMessage([String? textOverride]) {
    final text = textOverride ?? messageInputController.text.trim();
    if (text.isEmpty) return;

    final nowStr = _getFormattedTime();

    // Append user message
    messages.add(ChatMessage(text: text, isUser: true, time: nowStr));
    messageInputController.clear();
    _scrollToBottom();

    // Generate intelligent AI response after short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final aiResponse = _generateAiResponse(text);
      messages.add(ChatMessage(text: aiResponse, isUser: false, time: _getFormattedTime()));
      _scrollToBottom();
    });
  }

  String _generateAiResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('save') || q.contains('saving')) {
      return '💡 **Saving Advice:**\n\n1. Review your $annualSubCost SEK annual subscription costs.\n2. Canceling just 1 subscription like Netflix (179 kr/mo) will save you 2,148 kr/year!\n3. Set up an automatic transfer of 500 kr to your "Holiday" goal right after payday.';
    } else if (q.contains('subscription')) {
      return '📊 **Subscription Analysis:**\n\nYou currently have 3 subscriptions:\n• Netflix (179 kr)\n• Spotify (119 kr)\n• Disney+ (89 kr)\n\nThese account for 704% of your registered income. We recommend reducing subscription costs to under 10% of your income.';
    } else if (q.contains('food') || q.contains('overspend')) {
      return '🍔 **Expense Insight:**\n\nVariable costs like takeout and food delivery can quickly accumulate. Try setting a weekly food budget of 800 kr to stay safely on track.';
    } else if (q.contains('holiday') || q.contains('goal')) {
      return '🎯 **Goal Accelerator:**\n\nYour "Holiday" goal target is 33 SEK. With a modest 22 SEK/month contribution, you will reach it in less than 2 months!';
    }
    return '🤖 Based on your financial profile, focusing on reducing fixed expenses and controlling monthly subscriptions will boost your Health Score closest to 100%! What specific area would you like to optimize?';
  }

  int get annualSubCost => 387 * 12;

  String _getFormattedTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageInputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
