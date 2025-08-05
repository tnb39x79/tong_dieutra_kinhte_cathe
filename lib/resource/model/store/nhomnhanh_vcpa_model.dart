///Ngành vsic vcpa IO
class NhomnhanhVcpaModel {
  String? cap5;
  String? donViTinh;
  String? moTaNganhSanPham;
  String? linhVuc;
  String? cap1;

  NhomnhanhVcpaModel(
      {this.cap5,
      this.donViTinh,
      this.moTaNganhSanPham,
      this.linhVuc,
      this.cap1});

  NhomnhanhVcpaModel.fromJson(dynamic json) {
    cap5 = json['Cap5'];
    donViTinh = json['DonViTinh'];
    moTaNganhSanPham = json['MoTaNganhSanPham'];
    linhVuc = json['LinhVuc'];
    cap1 = json['Cap1'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['Cap5'] = cap5;
    map['DonViTinh'] = donViTinh;
    map['MoTaNganhSanPham'] = moTaNganhSanPham;
    map['LinhVuc'] = linhVuc;
    map['Cap1'] = cap1; 
    return map;
  }

  static List<NhomnhanhVcpaModel> listFromJson(dynamic json) {
    List<NhomnhanhVcpaModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(NhomnhanhVcpaModel.fromJson(value));
      }
    }
    return list;
  }
}
