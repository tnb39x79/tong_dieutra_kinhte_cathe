const String tableDmTongHopKQ = 'DmTongHopKQ'; 
const String columnDmTongHopKQId = 'Id';
const String columnDmTongHopKQMaPhieu = 'MaPhieu';
const String columnDmTongHopKQMaCauHoi = 'MaCauHoi';
const String columnDmTongHopKQMaSo = 'MaSo';
const String columnDmTongHopKQTenTruongChiTiet = 'TenTruongChiTiet';
const String columnDmTongHopKQTenTruongTongSo = 'TenTruongTongSo';

/// Gồm danh sách trường tính tổng hợp kết quả
class TableDmTongHopKQ {
  String? id;
  int? maPhieu;
  String? maCauHoi;
  String? maSo;
  String? tenTruongChiTiet;
  String? tenTruongTongSo;

  TableDmTongHopKQ(
      {this.id,
      this.maPhieu,
      this.maCauHoi,
      this.maSo,
      this.tenTruongChiTiet,
      this.tenTruongTongSo});

  TableDmTongHopKQ.fromJson(Map json) {
    id = json['Id'];
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    maSo = json['MaSo'];
    tenTruongChiTiet = json['TenTruongChiTiet'];
    tenTruongTongSo = json['TenTruongTongSo'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Id'] = id;
    data['MaPhieu'] = maPhieu;
    data['MaCauHoi'] = maCauHoi;
    data['MaSo'] = maSo;
    data['TenTruongChiTiet'] = tenTruongChiTiet;
    data['TenTruongTongSo'] = tenTruongTongSo;
    return data;
  }

  static List<TableDmTongHopKQ> listFromJson(dynamic localities) {
    List<TableDmTongHopKQ> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmTongHopKQ.fromJson(item));
      }
    }
    return list;
  }
}
