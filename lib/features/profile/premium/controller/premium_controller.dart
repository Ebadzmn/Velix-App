import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/storage_service.dart';

class PremiumController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  // Subscription plans: monthly plan as per requirements
  final RxString selectedPlan = 'monthly'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRestoring = false.obs;
  final RxBool isSubscribed = false.obs;
  final RxString activePlan = ''.obs;
  final Rx<DateTime?> expiresAt = Rx<DateTime?>(null);
  final RxInt daysRemaining = 0.obs;

  // Plan Details
  final String planTitle = 'monthly_sub_title';
  final RxString displayPrice = '25 kr'.obs;
  final String billingPeriod = '/ month';
  final String discountBadge = 'popular_badge';
  final String appleProductId = 'app.getvelix.monthly';

  // StoreKit Product Cache
  ProductDetails? availableProduct;
  final RxBool isStoreAvailable = false.obs;

  // Feature List with localization keys
  final List<Map<String, dynamic>> features = [
    {
      'titleKey': 'feature_ai_coach_title',
      'subtitleKey': 'feature_ai_coach_desc',
      'icon': 'flash',
      'isPro': true,
    },
    {
      'titleKey': 'feature_bank_sync_title',
      'subtitleKey': 'feature_bank_sync_desc',
      'icon': 'sync',
      'isPro': true,
    },
    {
      'titleKey': 'feature_cancel_assistant_title',
      'subtitleKey': 'feature_cancel_assistant_desc',
      'icon': 'shield',
      'isPro': true,
    },
    {
      'titleKey': 'feature_analytics_title',
      'subtitleKey': 'feature_analytics_desc',
      'icon': 'chart',
      'isPro': true,
    },
    {
      'titleKey': 'feature_custom_export_title',
      'subtitleKey': 'feature_custom_export_desc',
      'icon': 'folder',
      'isPro': true,
    },
    {
      'titleKey': 'feature_vip_support_title',
      'subtitleKey': 'feature_vip_support_desc',
      'icon': 'star',
      'isPro': true,
    },
  ];

  // Frequently Asked Questions
  final List<Map<String, String>> faqs = [
    {
      'q': 'How does the monthly subscription work?',
      'a': 'You will be billed 25 kr every month. You get immediate access to all premium features and can cancel anytime with zero cancellation fees.'
    },
    {
      'q': 'Can I cancel anytime?',
      'a': 'Yes! You can cancel anytime directly from your Apple ID Subscriptions settings or by contacting our concierge team.'
    },
    {
      'q': 'How do I restore my purchase on a new device?',
      'a': 'Simply tap the "Restore Purchases" button on this screen and we will reconnect your active Apple subscription automatically.'
    },
  ];

  final RxInt expandedFaqIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _initializeStoreKit();
    checkSubscriptionStatus();
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }

  void toggleFaq(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1;
    } else {
      expandedFaqIndex.value = index;
    }
  }

  // =========================================================================
  // 1. StoreKit & In-App Purchase Stream Initialization
  // =========================================================================
  Future<void> _initializeStoreKit() async {
    try {
      final available = await _inAppPurchase.isAvailable();
      isStoreAvailable.value = available;

      // Listen to the purchase stream from StoreKit
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
      _purchaseSubscription = purchaseUpdated.listen(
        _handlePurchaseUpdates,
        onDone: () => _purchaseSubscription?.cancel(),
        onError: (error) {
          debugPrint('InAppPurchase Stream error: $error');
        },
      );

      if (available) {
        await _loadProductDetails();
      }
    } catch (e) {
      debugPrint('Failed to initialize InAppPurchase: $e');
    }
  }

  Future<void> _loadProductDetails() async {
    try {
      final Set<String> kIds = <String>{appleProductId};
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(kIds);

      if (response.notFoundIDs.isEmpty && response.productDetails.isNotEmpty) {
        availableProduct = response.productDetails.first;
        displayPrice.value = availableProduct!.price;
      }
    } catch (e) {
      debugPrint('Error loading StoreKit product details: $e');
    }
  }

  // =========================================================================
  // 2. Handle In-App Purchases Updates (Purchased / Restored / Error / Pending)
  // =========================================================================
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        isLoading.value = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          isLoading.value = false;
          isRestoring.value = false;
          Get.snackbar(
            'Purchase Cancelled or Failed',
            purchaseDetails.error?.message ?? 'Transaction could not be completed.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Verify with Backend
          final isVerified = await _verifyPurchaseWithBackend(purchaseDetails);

          if (isVerified) {
            // Complete the purchase transaction with Apple StoreKit ONLY after successful verification
            if (purchaseDetails.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchaseDetails);
            }

            Get.snackbar(
              purchaseDetails.status == PurchaseStatus.restored
                  ? 'Purchases Restored 🎉'
                  : '🎉 Welcome to Premium!',
              'Your Apple subscription is now fully active.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF10B981),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 16,
              duration: const Duration(seconds: 4),
            );
          } else {
            Get.snackbar(
              'Verification Pending',
              'We could not verify your purchase with our servers right now. Please tap "Restore Purchases" to retry.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFF59E0B),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 16,
              duration: const Duration(seconds: 5),
            );
          }
        }

        isLoading.value = false;
        isRestoring.value = false;
      }
    }
  }

  // =========================================================================
  // 3. Verify Purchase with Backend Server
  // =========================================================================
  Future<bool> _verifyPurchaseWithBackend(PurchaseDetails purchase) async {
    try {
      final transactionId = purchase.purchaseID ?? purchase.verificationData.serverVerificationData;
      final serverVerificationData = purchase.verificationData.serverVerificationData;

      final response = await _apiClient.post(
        ApiEndpoints.appleSubscriptionVerify,
        data: {
          'transactionId': transactionId,
          'productId': purchase.productID,
          'originalTransactionId': transactionId,
          'receiptData': serverVerificationData,
          'purchaseDate': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        isSubscribed.value = true;
        activePlan.value = purchase.productID;

        // Update local user storage
        if (Get.isRegistered<StorageService>()) {
          final user = Get.find<StorageService>().getUser() ?? {};
          user['isPremium'] = true;
          user['premiumPlan'] = purchase.productID;
          await Get.find<StorageService>().saveUser(user);
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Backend verification error: $e');
      return false;
    }
  }

  // =========================================================================
  // 4. Check Current Status From Backend API
  // =========================================================================
  Future<void> checkSubscriptionStatus() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.appleSubscriptionStatus);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          isSubscribed.value = data['isPremium'] == true;
          activePlan.value = data['plan'] ?? '';
          daysRemaining.value = data['daysRemaining'] ?? 0;
          if (data['expiresAt'] != null) {
            expiresAt.value = DateTime.tryParse(data['expiresAt'].toString());
          }
        }
      }
    } catch (_) {
      // Fallback
    }
  }

  // =========================================================================
  // 5. Trigger Subscription Purchase (Strict Production StoreKit Flow)
  // =========================================================================
  Future<void> subscribe() async {
    // 1. Platform validation: Apple In-App Purchase is strictly for iOS devices
    if (!Platform.isIOS) {
      Get.snackbar(
        'iOS Exclusive Feature',
        'In-App Subscriptions are processed through the Apple App Store and are currently only available on iOS devices (iPhone / iPad).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1C38),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    // 2. StoreKit availability check
    if (!isStoreAvailable.value || availableProduct == null) {
      Get.snackbar(
        'App Store Unavailable',
        'Could not connect to Apple App Store. Please ensure you are signed in with an active Apple ID and have a working network connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    isLoading.value = true;
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: availableProduct!);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      // Flow continues in _handlePurchaseUpdates listener when StoreKit completes payment
    } catch (e) {
      Get.snackbar(
        'Purchase Error',
        'An error occurred initiating Apple purchase: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================================
  // 6. Restore Purchases (Strict Production StoreKit Flow)
  // =========================================================================
  Future<void> restorePurchases() async {
    if (!Platform.isIOS) {
      Get.snackbar(
        'iOS Exclusive Feature',
        'Restoring Apple subscriptions is only supported on iOS devices.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1C38),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (!isStoreAvailable.value) {
      Get.snackbar(
        'App Store Unavailable',
        'Unable to connect to Apple App Store to restore purchases.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isRestoring.value = true;
    try {
      await _inAppPurchase.restorePurchases();
      // Give StoreKit and backend verification time to process
      await Future.delayed(const Duration(seconds: 3));
      await checkSubscriptionStatus();

      if (!isSubscribed.value) {
        Get.snackbar(
          'Restore Purchases',
          'No active subscriptions were found for this Apple ID.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4B5563),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Restore Failed',
        'Could not restore purchases: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isRestoring.value = false;
    }
  }
}
