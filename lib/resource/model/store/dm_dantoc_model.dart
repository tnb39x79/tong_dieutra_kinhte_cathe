class DmDanTocModel {
  String? maMaDanToc;
  String? tenDanToc;
  String? tenGoiKhac;
  int? stt;

  DmDanTocModel({this.maMaDanToc, this.tenDanToc, this.stt});

  DmDanTocModel.fromJson(dynamic json) {
    maMaDanToc = json['MaDanToc'];
    tenDanToc = json['TenDanToc'];
    tenGoiKhac = json['TenGoiKhac'];
    stt = json['STT'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaDanToc'] = maMaDanToc;
    map['TenDanToc'] = tenDanToc;
    map['TenGoiKhac'] = tenGoiKhac;
    map['STT'] = stt;
    return map;
  }

  static List<DmDanTocModel> listFromJson(dynamic json) {
    List<DmDanTocModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(DmDanTocModel.fromJson(value));
      }
    }
    return list;
  }
}
