import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';

import 'question_phieu_vt_controller.dart';

 

class QuestionPhieuVTBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QuestionPhieuVTController(vcpaVsicAIRepository: Get.find())); 
  }
}
