import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';

import 'question_phieu_lt_controller.dart';

 
class QuestionPhieuLTBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionPhieuLTController(vcpaVsicAIRepository: Get.find())); 
  }
}
