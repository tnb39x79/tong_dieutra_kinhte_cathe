///Tình trạng hoạt động
class ActiveStatusModel {
  int? maTinhTrang;
  String? tenTinhTrang;
  int? maDoiTuongDT;

  ActiveStatusModel({
    this.maTinhTrang,
    this.tenTinhTrang,
    this.maDoiTuongDT
  });

  ActiveStatusModel.fromJson(dynamic json) {
    maTinhTrang = json['MaTinhTrang'];
    tenTinhTrang = json['TenTinhTrang'];
    maDoiTuongDT=json['MaDoiTuongDT'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaTinhTrang'] = maTinhTrang;
    map['TenTinhTrang'] = tenTinhTrang;
    map['MaDoiTuongDT'] = maDoiTuongDT;
    return map;
  }

  static List<ActiveStatusModel> listFromJson(dynamic json) {
    List<ActiveStatusModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(ActiveStatusModel.fromJson(value));
      }
    }
    return list;
  }
}
