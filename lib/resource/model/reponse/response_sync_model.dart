  
import 'package:gov_statistics_investigation_economic/resource/model/sync/sync_result.dart';

class ResponseSyncModel {
  String? responseCode;
  String? responseMessage;
  bool? isSuccess;
  List<SyncResult>? syncResults; 
  ResponseSyncModel({
    this.responseCode,
    this.responseMessage,
    this.isSuccess,
    this.syncResults, 
  });
 
}
