///Địa điểm sản xuất kinh doanh
class BusinessLocationModel {
  int? ma;
  String? ten;
  int? ghiRo;

  BusinessLocationModel({
    this.ma,
    this.ten,
    this.ghiRo
  });

  BusinessLocationModel.fromJson(dynamic json) {
    ma = json['Ma'];
    ten = json['Ten'];
    ghiRo = json['GhiRo'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Ma'] = ma;
    map['Ten'] = ten;
     map['GhiRo'] = ghiRo;
    return map;
  }

  static List<BusinessLocationModel> listFromJson(dynamic json) {
    List<BusinessLocationModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(BusinessLocationModel.fromJson(value));
      }
    }
    return list;
  }
}
