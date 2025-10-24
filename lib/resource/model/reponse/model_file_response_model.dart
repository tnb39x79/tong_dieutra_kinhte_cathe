/// Model for GetModelFile API response
/// This model represents the response from api/GetModelFile endpoint
/// which provides download URLs and filenames for AI models (VCPA and STT)
class ModelFileResponseModel {
  int? id;
  String? fileUrlVCPALink01;
  String? fileUrlVCPALink02;
  String? vcpaFileName;
  String? fileUrlSTTLink01;
  String? fileUrlSTTLink02;
  String? sttFileName;

  ModelFileResponseModel({
    this.id,
    this.fileUrlVCPALink01,
    this.fileUrlVCPALink02,
    this.vcpaFileName,
    this.fileUrlSTTLink01,
    this.fileUrlSTTLink02,
    this.sttFileName,
  });

  ModelFileResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    fileUrlVCPALink01 = json['FileUrl_VCPA_Link01'];
    fileUrlVCPALink02 = json['FileUrl_VCPA_Link02'];
    vcpaFileName = json['VCPA_FileName'];
    fileUrlSTTLink01 = json['FileUrl_STT_Link01'];
    fileUrlSTTLink02 = json['FileUrl_STT_Link02'];
    sttFileName = json['STT_FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['FileUrl_VCPA_Link01'] = fileUrlVCPALink01;
    data['FileUrl_VCPA_Link02'] = fileUrlVCPALink02;
    data['VCPA_FileName'] = vcpaFileName;
    data['FileUrl_STT_Link01'] = fileUrlSTTLink01;
    data['FileUrl_STT_Link02'] = fileUrlSTTLink02;
    data['STT_FileName'] = sttFileName;
    return data;
  }

  @override
  String toString() {
    return 'ModelFileResponseModel{id: $id, fileUrlVCPALink01: $fileUrlVCPALink01, fileUrlVCPALink02: $fileUrlVCPALink02, vcpaFileName: $vcpaFileName, fileUrlSTTLink01: $fileUrlSTTLink01, fileUrlSTTLink02: $fileUrlSTTLink02, sttFileName: $sttFileName}';
  }
}
