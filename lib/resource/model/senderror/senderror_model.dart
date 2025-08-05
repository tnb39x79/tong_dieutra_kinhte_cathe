class SendErrorModel {
  String? responseCode;
  String? responseMessage;  

  SendErrorModel({
    this.responseCode,
    this.responseMessage, 
  });

  SendErrorModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    responseMessage = json['ResponseMessage']; 
  }

 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['ResponseMessage'] = responseMessage; 
    return data;
  }
}
