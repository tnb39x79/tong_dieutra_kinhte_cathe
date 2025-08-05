import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/auth/auth.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_repository.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/update_data/xacnhan_tukekhai_provider.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/update_data/xacnhan_tukekhai_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(NetworkService(), permanent: true);

    // auth
    Get.put(AuthProvider(), permanent: true);
    Get.put(AuthRepository(provider: Get.find()));
    Get.put(InputDataProvider(), permanent: true);
    Get.put(InputDataRepository(provider: Get.find()));
    Get.put(SyncProvider(), permanent: true);
    Get.put(SyncRepository(provider: Get.find()), permanent: true);
    Get.put(SendErrorProvider(), permanent: true);
    Get.put(SendErrorRepository(provider: Get.find()), permanent: true);
    Get.put(ErrorLogProvider(), permanent: true);
    Get.put(ErrorLogRepository(provider: Get.find()), permanent: true);
    Get.put(VcpaVsicAISearchProvider(), permanent: true);
    Get.put(VcpaVsicAIRepository(provider: Get.find()), permanent: true);
    Get.put(XacnhanTukekhaiProvider(), permanent: true);
    Get.put(XacnhanTukekhaiRepository(provider: Get.find()), permanent: true);
  }
}
