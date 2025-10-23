import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';
import 'package:gov_statistics_investigation_economic/config/constants/app_values.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class VcpaVsicAISearchProvider extends GetConnect {
//http://sic3_api1.gso.gov.vn:8000/api/v1/branch-codes/get-suggestions?data_type=vsic&query=%C4%83n%20u%E1%BB%91ng&top_k=5
  String funcPath = 'api/v1/branch-codes/get-suggestions';

  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 60); // default timeout = 8 s,
    httpClient.addAuthenticator(authInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }

  Future<Response> searchVcpaVsicByAI(String codeType, String query,
      {int? limitNum = 10}) async {
    Map<String, String>? headers = {'Authorization': 'Bearer '};
    httpClient.timeout = const Duration(seconds: 15);

     String baseSuggestionUrl = AppPref.suggestionVcpaUrl;
    if (baseSuggestionUrl.isNotEmpty) {
      String lastChar = baseSuggestionUrl[baseSuggestionUrl.length - 1];
      if (lastChar != '/') {
        baseSuggestionUrl = '${AppPref.suggestionVcpaUrl}/';
      }
    }
    String urlSearch =
        '${baseSuggestionUrl}$funcPath?data_type=$codeType&query=$query&top_k=$limitNum';
        print(urlSearch);
    try {
      var response = get(
        urlSearch,
      //  headers: headers,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return const Response(
              statusCode: HttpStatus.requestTimeout,
              statusText: "Request timeout");
        },
      );
      return response;
    } on TimeoutException catch (e) {
      // catch timeout here..
      return Response(
          statusCode: HttpStatus.requestTimeout, statusText: e.message);
    } catch (e) {
      return Response(
          statusCode: ApiConstants.errorException, statusText: e.toString());
    }
  }

  
}
