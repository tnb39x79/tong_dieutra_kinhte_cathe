import 'dart:async';
import 'dart:convert';

import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/resource/model/product/product_ai_model.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';
import 'package:gov_statistics_investigation_economic/resource/services/api/search_sp/vcpa_vsic_ai_search_provider.dart';

class VcpaVsicAIRepository {
  VcpaVsicAIRepository({required this.provider});
  final VcpaVsicAISearchProvider provider;

  Future<ResponseModel<List<ProductAiModel>>> searchVcpaVsicByAI(
      String codeType, String query,
      {int? limitNum = 10}) async {
    if (NetworkService.connectionType == Network.none) {
      return ResponseModel.withDisconnect();
    }
    try {
      final data = await provider.searchVcpaVsicByAI(codeType, query,
          limitNum: limitNum);
      if (data.statusCode == ApiConstants.success) {
        final bodyString = await data.body;
        final bodyDecoder = jsonDecode(bodyString);

        if (bodyDecoder is List) {
          print('decoder is a List (JSON array).');
          return ResponseModel(
              statusCode: data.statusCode,
              body: ProductAiModel.listFromJson(data.body));
        } else if (bodyDecoder is Map) {
          print('decoder is a Map (JSON object).');
          final dataDecoded = bodyDecoder['codes'] as List;
          var result =
              dataDecoded.map((e) => ProductAiModel.fromJson(e)).toList();
          return ResponseModel(statusCode: data.statusCode, body: result);
        } else {
          return ResponseModel.withError(data);
        }
      } else if (data.statusCode == HttpStatus.requestTimeout) {
        return ResponseModel.withRequestTimeout();
      } else {
        return ResponseModel.withError(data);
      }
    } on TimeoutException catch (_) {
      return ResponseModel.withRequestTimeout();
    } catch (e) {
      return ResponseModel.withRequestException(e);
    }
  }
}
