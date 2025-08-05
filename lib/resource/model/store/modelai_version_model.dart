///Trạng thái điều tra
class ModelAIVersionModel {
   int? id;
  String? modelFileUrl;
  String? version;


  ModelAIVersionModel({
    this.id,
    this.modelFileUrl,
    this.version
  });

  ModelAIVersionModel.fromJson(dynamic json) {
    id = json['Id'];
    modelFileUrl = json['ModelFileUrl'];
    version = json['Version'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Id'] = id;
    map['ModelFileUrl'] = modelFileUrl;
     map['Version'] = version;
    return map;
  }

  static List<ModelAIVersionModel> listFromJson(dynamic json) {
    List<ModelAIVersionModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(ModelAIVersionModel.fromJson(value));
      }
    }
    return list;
  }
}
