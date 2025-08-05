///Trạng thái điều tra
class LoainganhIoModel {
  String? maIO;
  String? loaiIO;
  int? sTT;

  LoainganhIoModel({
    this.maIO,
    this.loaiIO,
    this.sTT
  });

  LoainganhIoModel.fromJson(dynamic json) {
    maIO = json['MaIO'];
    loaiIO = json['LoaiIO'];
    sTT = json['STT'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaIO'] = maIO;
    map['LoaiIO'] = loaiIO;
     map['STT'] = sTT;
    return map;
  }

  static List<LoainganhIoModel> listFromJson(dynamic json) {
    List<LoainganhIoModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(LoainganhIoModel.fromJson(value));
      }
    }
    return list;
  }
}
