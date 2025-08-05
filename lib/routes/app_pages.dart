import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/download_model_ai_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/download_model_ai_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/introduce_module/splash/splash.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/progress_list/progress_list_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/progress_list/progress_list_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_no07_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_no07_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/sync_module/sync_module.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: AppRoutes.splash,
        page: () => const SplashScreen(),
        binding: SplashBinding(),
        transition: Transition.fade),
    GetPage(
        name: AppRoutes.login,
        page: () => const LoginScreen(),
        binding: LoginBinding()),
    GetPage(
        name: AppRoutes.mainMenu,
        page: () => const MainMenuScreen(),
        binding: MainMenuBinding()),
    GetPage(
        name: AppRoutes.interviewObjectList,
        page: () => const InterviewObjectListScreen(),
        binding: InterviewObjectListBinding(),
        transition: Transition.fade),
    GetPage(
        name: AppRoutes.interviewList,
        page: () => const InterviewListScreen(),
        binding: InterviewListBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.interviewLocationList,
        page: () => const InterviewLocationListScreen(),
        binding: InterviewLocationListBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.interviewListDetail,
        page: () => const InterviewListDetailScreen(),
        binding: InterviewListDetailBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.progress,
        page: () => const ProgressListScreen(),
        binding: ProgressListBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.activeStatus,
        page: () => const ActiveStatusScreen(),
        binding: ActiveStatusBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.generalInformation,
        page: () => const GeneralInformationScreen(),
        binding: GeneralInformationBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.question07,
        page: () => const QuestionNo07Screen(),
        binding: QuestionNo07Binding(),
        transition: Transition.rightToLeft),
    // GetPage(
    //     name: AppRoutes.question08,
    //     page: () => const QuestionNo08Screen(),
    //     binding: QuestionNo08Binding(),
    //     transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.sync,
        page: () => const SyncScreen(),
        binding: SyncBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.downloadModelAI,
        page: () => const DownloadModelAIScreen(),
        binding: DownloadModelAIBinding(),
        transition: Transition.rightToLeft),
  ];
}
