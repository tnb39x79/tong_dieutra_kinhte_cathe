const String tableDmMoTaSanPham = 'DmMoTaSanPham';
const String columnDmMoTaSPId = '_id';
const String columnDmMoTaSPMaSanPham = 'MaSanPham';
const String columnDmMoTaSPTenSanPham = 'TenSanPham';
const String columnDmMoTaSPTenSanPhamKoDau = 'TenSanPhamKoDau';
const String columnDmMoTaSPMoTaChiTiet = 'MoTaChiTiet';
const String columnDmMoTaSPMoTaChiTietKoDau = 'MoTaChiTietKoDau';
const String columnDmMoTaSPDonViTinh = 'DonViTinh';
const String columnDmMoTaSPMaLV = 'MaLV';
const String columnDmMoTaSPTenLinhVuc = 'TenLinhVuc';

class TableDmMotaSanpham {
  int? id;
  String? maSanPham;
  String? tenSanPham;
  String? tenSanPhamKoDau;
  String? moTaChiTiet;
  String? moTaChiTietKoDau;
  String? donViTinh;
  String? maLV;
  String? tenLinhVuc;

  TableDmMotaSanpham(
      {this.id,
      this.maSanPham,
      this.tenSanPham,
      this.tenSanPhamKoDau,
      this.moTaChiTiet,
      this.moTaChiTietKoDau,
      this.donViTinh,
      this.maLV,
      this.tenLinhVuc});

  TableDmMotaSanpham.fromJson(Map json) {
    id = json['_id'];
    maSanPham = json['MaSanPham'];
    tenSanPham = json['TenSanPham'];
    tenSanPhamKoDau = json['TenSanPhamKoDau'];
    moTaChiTiet = json['MoTaChiTiet'];
    moTaChiTietKoDau = json['MoTaChiTietKoDau'];
    donViTinh = json['DonViTinh'];
    maLV = json['MaLV'];
    tenLinhVuc = json['TenLinhVuc'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaSanPham'] = maSanPham;
    data['TenSanPham'] = tenSanPham;
    data['TenSanPhamKoDau'] = tenSanPhamKoDau;
    data['MoTaChiTiet'] = moTaChiTiet;
    data['MoTaChiTietKoDau'] = moTaChiTietKoDau;
    data['DonViTinh'] = donViTinh;
    data['MaLV'] = maLV;
    data['TenLinhVuc'] = tenLinhVuc;
    return data;
  }

  static List<TableDmMotaSanpham> listFromJson(dynamic localities) {
    List<TableDmMotaSanpham> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmMotaSanpham.fromJson(item));
      }
    }
    return list;
  }
}
