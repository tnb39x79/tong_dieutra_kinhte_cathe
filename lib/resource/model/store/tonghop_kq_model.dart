///Trạng thái điều tra
class TonghopKqModel {
  String? id;
  int? maPhieu;
  String? maCauHoi;
  String? maSo;
  String? tenTruongChiTiet;
  String? tenTruongTongSo;

  TonghopKqModel(
      {this.id,
      this.maPhieu,
      this.maCauHoi,
      this.maSo,
      this.tenTruongChiTiet,
      this.tenTruongTongSo});

  TonghopKqModel.fromJson(dynamic json) {
    id = json['Id'];
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    maSo = json['MaSo'];
    tenTruongChiTiet = json['TenTruongChiTiet'];
    tenTruongTongSo = json['TenTruongTongSo'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Id'] = id;
    map['MaPhieu'] = maPhieu;
    map['MaCauHoi'] = maCauHoi;
    map['MaSo'] = maSo;
    map['TenTruongChiTiet'] = tenTruongChiTiet;
    map['TenTruongTongSo'] = tenTruongTongSo;
    return map;
  }

  static List<TonghopKqModel> listFromJson(dynamic json) {
    List<TonghopKqModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(TonghopKqModel.fromJson(value));
      }
    }
    return list;
  }
}
