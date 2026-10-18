import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../home/controller/home_controller.dart';
import '../models/insights_model.dart';

class InsightsController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final isLoading = false.obs;

  // Financial health observables
  final healthData = FinancialHealthData().obs;
  final healthScore = 0.obs;
  final healthStatus = 'Good'.obs;
  final healthDescription = ''.obs;

  // Points breakdown observables
  final savingsQuota = '0 %'.obs;
  final subscriptionControl = '0 %'.obs;
  final budgetControl = '0 %'.obs;

  // Quick metrics observables
  final subscriptionCount = 0.obs;
  final annualCostText = '0 SEK'.obs;
  final percentageOfIncomeText = '0%'.obs;

  // Dynamic smart insight items
  final RxList<SmartInsightItem> smartInsightsList = <SmartInsightItem>[].obs;
  final aiCoachData = Rxn<AiCoachData>();

  @override
  void onInit() {
    super.onInit();
    _loadFromHomeController();
    fetchSmartInsights();
  }

  void _loadFromHomeController() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      healthScore.value = homeController.healthScore.value;
      healthStatus.value = homeController.healthStatus.value;
      subscriptionCount.value = homeController.subscriptions.length;
      final monthly = homeController.monthlySubscriptionTotal.value;
      final annual = monthly * 12;
      final curr = homeController.userCurrency.value;
      annualCostText.value = '${annual.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} $curr';
    }
  }

  Future<void> fetchSmartInsights() async {
    isLoading.value = true;
    try {
      // First try /api/v1/insights, fallback to /api/v1/smart-insights
      dynamic response;
      try {
        response = await _apiClient.get(ApiEndpoints.insights);
      } catch (e) {
        // If /api/v1/insights failed (e.g. 404), try /api/v1/smart-insights
        try {
          response = await _apiClient.get(ApiEndpoints.smartInsights);
        } catch (innerError) {
          // Keep inner error
        }
      }

      if (response != null && (response.statusCode == 200 || response.statusCode == 201) && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is Map<String, dynamic>) {
          // 1. Financial Health
          if (data['financial_health'] != null) {
            final fh = FinancialHealthData.fromJson(data['financial_health']);
            healthData.value = fh;
            healthScore.value = fh.score;
            healthStatus.value = fh.status;
            healthDescription.value = fh.description;
          } else if (data['economic_health'] != null) {
            final fh = FinancialHealthData.fromJson(data['economic_health']);
            healthData.value = fh;
            healthScore.value = fh.score;
            healthStatus.value = fh.status;
            healthDescription.value = fh.description;
          } else if (data['economic_health_score'] != null) {
            final score = (data['economic_health_score'] as num).toInt();
            healthScore.value = score;
          }

          // 2. Points Breakdown
          if (data['points_breakdown'] != null && data['points_breakdown'] is Map) {
            final pb = data['points_breakdown'] as Map<String, dynamic>;
            if (pb['savings'] != null) {
              final cat = PointsBreakdownCategory.fromJson(pb['savings'] as Map<String, dynamic>?);
              savingsQuota.value = '${cat.percentage.toInt()} %';
            }
            if (pb['subscription_control'] != null) {
              final cat = PointsBreakdownCategory.fromJson(pb['subscription_control'] as Map<String, dynamic>?);
              subscriptionControl.value = '${cat.percentage.toInt()} %';
            }
            if (pb['budget_control'] != null) {
              final cat = PointsBreakdownCategory.fromJson(pb['budget_control'] as Map<String, dynamic>?);
              budgetControl.value = '${cat.percentage.toInt()} %';
            }
          }

          // 3. Quick Metric Stats
          if (data['quick_metric_stats'] != null) {
            final qm = QuickMetricStats.fromJson(data['quick_metric_stats'] as Map<String, dynamic>?);
            subscriptionCount.value = qm.subscriptionCount;
            annualCostText.value = qm.yearlyCostFormatted;
            percentageOfIncomeText.value = '${qm.subscriptionIncomePercentage.toStringAsFixed(1)}%';
          }

          // 4. Smart Insights Items
          if (data['smart_insights'] != null && data['smart_insights'] is List) {
            final list = (data['smart_insights'] as List)
                .map((item) => SmartInsightItem.fromJson(item as Map<String, dynamic>))
                .toList();
            smartInsightsList.value = list;
          }

          // 5. AI Coach
          if (data['ai_coach'] != null) {
            aiCoachData.value = AiCoachData.fromJson(data['ai_coach'] as Map<String, dynamic>?);
          }
        }
      }
    } catch (_) {
      // Retain existing state on unexpected error
    } finally {
      isLoading.value = false;
    }
  }
}
