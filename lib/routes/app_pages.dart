import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/download_model_ai_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/download_model_ai_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/enhanced_ai_download_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/dashboard_module/download_model_ai/enhanced_ai_download_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/introduce_module/splash/splash.dart';
import 'package:gov_statistics_investigation_economic/modules/modules.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/progress_list/progress_list_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/progress_module/progress_list/progress_list_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_no07_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_no07_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_cn_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_cn_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_lt_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_lt_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/question_phieu_tb_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_tm_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_tm_screen.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_vt_binding.dart';
import 'package:gov_statistics_investigation_economic/modules/question_module/question_no07/phieu_nganh/question_phieu_vt_screen.dart';
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
        name: AppRoutes.questionTB,
        page: () => const QuestionPhieuTBScreen(),
        binding: QuestionPhieuTBBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.questionPhieuCN,
        page: () => const QuestionPhieuCNScreen(),
        binding: QuestionPhieuCNBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.questionPhieuVT,
        page: () => const QuestionPhieuVTScreen(),
        binding: QuestionPhieuVTBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.questionPhieuLT,
        page: () => const QuestionPhieuLTScreen(),
        binding: QuestionPhieuLTBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: AppRoutes.questionPhieuTM,
        page: () => const QuestionPhieuTMScreen(),
        binding: QuestionPhieuTMBinding(),
        transition: Transition.rightToLeft),
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
    GetPage(
      name: AppRoutes.downloadModelAI_V2,
      page: () => const EnhancedAiDownloadScreen(),
      binding: EnhancedAiDownloadBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
