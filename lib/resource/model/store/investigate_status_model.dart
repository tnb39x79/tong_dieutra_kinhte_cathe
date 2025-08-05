///Trạng thái điều tra
class InvestigateStatusModel {
  int? maTrangThaiDT;
  String? tenTrangThaiDT;

  InvestigateStatusModel({
    this.maTrangThaiDT,
    this.tenTrangThaiDT,
  });

  InvestigateStatusModel.fromJson(dynamic json) {
    maTrangThaiDT = json['MaTrangThaiDT'];
    tenTrangThaiDT = json['TenTrangThaiDT'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaTrangThaiDT'] = maTrangThaiDT;
    map['TenTrangThaiDT'] = tenTrangThaiDT;
    return map;
  }

  static List<InvestigateStatusModel> listFromJson(dynamic json) {
    List<InvestigateStatusModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(InvestigateStatusModel.fromJson(value));
      }
    }
    return list;
  }
}
