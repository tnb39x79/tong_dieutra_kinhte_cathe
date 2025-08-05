///Ngành vsic vcpa IO
class VcpaCap5Model {
  String? cap1;
  String? cap2;
  String? cap3;
  String? cap4;
  String? cap5;
  String? tenNganh;
  int? sTT;

  VcpaCap5Model({
    this.cap1,
    this.cap2,
    this.cap3,
    this.cap4,
    this.cap5,
    this.tenNganh,
    this.sTT
  });

  VcpaCap5Model.fromJson(dynamic json) {
    cap1 = json['Cap1'];
    cap2 = json['Cap2'];
    cap3 = json['Cap3'];
    cap4 = json['Cap4'];
    cap5 = json['Cap5'];
    tenNganh= json['TenNganh'];
      sTT = json['STT'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Cap1'] = cap1;
    map['Cap2'] = cap2;
     map['Cap3'] = cap3;
    map['Cap4'] = cap4;
    map['Cap5'] = cap5;
    map['TenNganh'] = tenNganh;
    map['STT'] = sTT;
    return map;
  }

  static List<VcpaCap5Model> listFromJson(dynamic json) {
    List<VcpaCap5Model> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(VcpaCap5Model.fromJson(value));
      }
    }
    return list;
  }
}
