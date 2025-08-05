import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_result.dart';

class SyncModel {
  String? responseCode;
  String? responseMessage;
  SuccessCount? successCount;
  SuccessCount? failedCount;
  SuccessCount? totalCount;
  List<SyncResult>? syncResults; 

  SyncModel(
      {this.responseCode,
      this.responseMessage,
      this.successCount,
      this.failedCount,
      this.totalCount,
      this.syncResults});

  SyncModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage'];

    successCount = json['SuccessCount'] != null
        ? SuccessCount.fromJson(json['SuccessCount'])
        : null;
    failedCount = json['FailedCount'] != null
        ? SuccessCount.fromJson(json['FailedCount'])
        : null;
    totalCount = json['TotalCount'] != null
        ? SuccessCount.fromJson(json['TotalCount'])
        : null;
    syncResults = json['SyncResults'] != null
        ? SyncResult.listFromJson(json['SyncResults'])
        : null; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage;

    if (successCount != null) {
      data['SuccessCount'] = successCount!.toJson();
    }
    if (failedCount != null) {
      data['FailedCount'] = failedCount!.toJson();
    }
    if (totalCount != null) {
      data['TotalCount'] = totalCount!.toJson();
    }
    return data;
  }
}

class SuccessCount {
  int? countCoSo;
  int? countHo;
  int? countPhieu04;
  int? countPhieu05;
  List? coSo;
  List? ho;
  SuccessCount(
      {this.countCoSo,
      this.countHo,
      this.countPhieu04,
      this.countPhieu05,
      this.coSo,
      this.ho});

  SuccessCount.fromJson(Map<String, dynamic> json) {
    countCoSo = json['CountCoSo'];
    countHo = json['CountHo'];
    countPhieu04 = json['CountPhieu04'];
    countPhieu05 = json['CountPhieu05'];
    coSo = json['CoSo'];
    ho = json['Ho'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CountCoSo'] = countCoSo;
    data['CountHo'] = countHo;
    data['CountPhieu04'] = countPhieu04;
    data['CountPhieu05'] = countPhieu05;
    data['CoSo'] = coSo;
    data['Ho'] = ho;

    return data;
  }
}
