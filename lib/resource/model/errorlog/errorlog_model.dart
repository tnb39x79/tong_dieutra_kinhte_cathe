class ErrorLogModel {
  String? errorCode;
  String? errorMessage;  

  ErrorLogModel({
    this.errorCode,
    this.errorMessage, 
  });

  ErrorLogModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage']; 
  }

 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = errorCode;
    data['ErrorMessage'] = errorMessage; 
    return data;
  }
}
