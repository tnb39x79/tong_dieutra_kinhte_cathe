const String tableCTDmPhieu = 'CT_DM_Phieu';
const String colPhieuMaPhieu = 'MaPhieu';
const String colPhieuTenPhieu = 'TenPhieu';
const String colPhieuBangDuLieu = 'BangDuLieu';
const String colPhieuGhiChu = 'GhiChu';
const String colPhieuTenHienThi = 'TenHienThi';
const String colPhieuTenHienThiCapi = 'TenHienThiCapi';
const String colPhieuTenPhieuCapi = 'TenPhieuCapi';
const String colPhieuActive = 'Active';

class TableCTDmPhieu {
  int? id;
  int? maPhieu;
  String? tenPhieu;
  String? bangDuLieu;
  String? ghiChu;
  String? tenHienThi;
  String? tenHienThiCapi;
  String? tenPhieuCapi;
  int? active;

  TableCTDmPhieu({
    this.maPhieu,
    this.tenPhieu,
    this.bangDuLieu,
    this.ghiChu,
    this.tenHienThi,
    this.tenHienThiCapi,
    this.tenPhieuCapi,
    this.active,
  });

  TableCTDmPhieu.fromJson(Map json) {
    id = json['_id'];
    maPhieu = json['MaPhieu'];
    tenPhieu = json['TenPhieu'];
    bangDuLieu = json['BangDuLieu'];
    ghiChu = json['GhiChu'];
    tenHienThi = json['TenHienThi'];
    tenHienThiCapi = json['TenHienThiCapi'];
    tenPhieuCapi = json['TenPhieuCapi'];
    active = json['Active'];
  }

  Map<String, Object?> toJson() {
    final json = <String, Object?>{};
    json['MaPhieu'] = maPhieu;
    json['TenPhieu'] = tenPhieu;
    json['BangDuLieu'] = bangDuLieu;
    json['GhiChu'] = ghiChu;
    json['TenHienThi'] = tenHienThi;
    json['TenHienThiCapi'] = tenHienThiCapi;
    json['TenPhieuCapi'] = tenPhieuCapi;
    json['Active'] = active;
    return json;
  }

  static List<TableCTDmPhieu> listFromJson(dynamic localities) {
    List<TableCTDmPhieu> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmPhieu.fromJson(item));
      }
    }
    return list;
  }
}
