const String tableCTDmNhomNganhVcpa = 'CT_DmNhomNganhVcpa';
const String columnCTDmNhomNganhVcpaId = '_id';
const String columnCTDmNhomNganhVcpaCap5 = 'Cap5';
const String columnCTDmNhomNganhVcpaDonViTinh = 'DonViTinh';
const String columnCTDmNhomNganhVcpaMoTaNganhSanPham = 'MoTaNganhSanPham';
const String columnCTDmNhomNganhVcpaLinhVuc = 'LinhVuc';
const String columnCTDmNhomNganhVcpaCap1 = 'Cap1';

class TableCTDmNhomNganhVcpa {
  int? id;
  String? cap5;
  String? donViTinh;
  String? moTaNganhSanPham;
  String? linhVuc;
  String? cap1;

  TableCTDmNhomNganhVcpa(
      {this.id,
      this.cap5,
      this.donViTinh,
      this.moTaNganhSanPham,
      this.linhVuc,
      this.cap1});

  // TableCTDmNhomNganhVcpa.fromJson(Map<String, dynamic> json) {
  //   cap5 = json['Cap5'];
  //   donViTinh = json['DonViTinh'];
  //   moTaNganhSanPham = json['MoTaNganhSanPham'];
  //   linhVuc = json['LinhVuc'];
  //   cap1 = json['Cap1'];
  // }
  TableCTDmNhomNganhVcpa.fromJson(Map json) {
    cap5 = json['Cap5'];
    donViTinh = json['DonViTinh'];
    moTaNganhSanPham = json['MoTaNganhSanPham'];
    linhVuc = json['LinhVuc'];
    cap1 = json['Cap1'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, Object?>{};
    data['Cap5'] = cap5;
    data['DonViTinh'] = donViTinh;
    data['MoTaNganhSanPham'] = moTaNganhSanPham;
    data['LinhVuc'] = linhVuc;
    data['Cap1'] = cap1;
    return data;
  }

  static List<TableCTDmNhomNganhVcpa> listFromJson(dynamic localities) {
    List<TableCTDmNhomNganhVcpa> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmNhomNganhVcpa.fromJson(item));
      }
    }
    return list;
  }
}
