import 'package:get/get.dart';
import '../features/splash/splash_binding.dart';
import '../features/splash/page/splash_page.dart';
import '../features/onboarding/onboarding_binding.dart';
import '../features/onboarding/page/onboarding_page.dart';
import '../features/auth/login/login_binding.dart';
import '../features/auth/login/page/login_page.dart';
import '../features/auth/signup/signup_binding.dart';
import '../features/auth/signup/page/signup_page.dart';
import '../features/questionnaire/questionnaire_binding.dart';
import '../features/questionnaire/page/questionnaire_page.dart';
import '../features/home/home_binding.dart';
import '../features/home/page/home_page.dart';
import '../features/profile/achievements/achievements_binding.dart';
import '../features/profile/achievements/page/achievements_page.dart';
import '../features/profile/settings/settings_binding.dart';
import '../features/profile/settings/page/settings_page.dart';
import '../features/profile/beta_program/beta_program_binding.dart';
import '../features/profile/beta_program/page/beta_program_page.dart';
import '../features/profile/edit_profile/edit_profile_binding.dart';
import '../features/profile/edit_profile/page/edit_profile_page.dart';
import '../features/subscription/new_subscription/new_subscription_binding.dart';
import '../features/subscription/new_subscription/page/new_subscription_page.dart';
import '../features/costs/add_cost/add_cost_binding.dart';
import '../features/costs/add_cost/page/add_cost_page.dart';
import '../features/profile/insights/insights_binding.dart';
import '../features/profile/insights/page/insights_page.dart';
import '../features/ai_coach/ai_coach_binding.dart';
import '../features/ai_coach/page/ai_coach_page.dart';
import '../features/subscription/subscription_detail/subscription_detail_binding.dart';
import '../features/subscription/subscription_detail/page/subscription_detail_page.dart';
import '../features/profile/premium/premium_binding.dart';
import '../features/profile/premium/page/upgrade_premium_page.dart';
import '../features/notification/notification_binding.dart';
import '../features/notification/page/notification_page.dart';
import '../features/savings_goal/savings_goal_binding.dart';
import '../features/savings_goal/page/savings_goal_page.dart';
import '../features/profile/help_support/help_support_page.dart';
import '../features/profile/privacy_policy/privacy_policy_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupPage(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.questionnaire,
      page: () => const QuestionnairePage(),
      binding: QuestionnaireBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.achievements,
      page: () => const AchievementsPage(),
      binding: AchievementsBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.betaProgram,
      page: () => const BetaProgramPage(),
      binding: BetaProgramBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfilePage(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.newSubscription,
      page: () => const NewSubscriptionPage(),
      binding: NewSubscriptionBinding(),
    ),
    GetPage(
      name: Routes.addCost,
      page: () => const AddCostPage(),
      binding: AddCostBinding(),
    ),
    GetPage(
      name: Routes.insights,
      page: () => const InsightsPage(),
      binding: InsightsBinding(),
    ),
    GetPage(
      name: Routes.aiCoach,
      page: () => const AiCoachPage(),
      binding: AiCoachBinding(),
    ),
    GetPage(
      name: Routes.subscriptionDetail,
      page: () => const SubscriptionDetailPage(),
      binding: SubscriptionDetailBinding(),
    ),
    GetPage(
      name: Routes.upgradePremium,
      page: () => const UpgradePremiumPage(),
      binding: PremiumBinding(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationPage(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.savingsGoals,
      page: () => const SavingsGoalPage(),
      binding: SavingsGoalBinding(),
    ),
    GetPage(
      name: Routes.helpSupport,
      page: () => const HelpSupportPage(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
    ),
  ];
}
