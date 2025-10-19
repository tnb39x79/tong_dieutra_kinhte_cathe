const String tableDmMoTaSanPham = 'CT_DM_MoTaSanPham';
const String columnDmMoTaSPId = '_id';
const String columnDmMoTaSPMaSanPham = 'MaSanPham';
const String columnDmMoTaSPTenSanPham = 'TenSanPham';
const String columnDmMoTaSPTenSanPhamKoDau = 'TenSanPhamKoDau';
const String columnDmMoTaSPMoTaChiTiet = 'MoTaChiTiet';
const String columnDmMoTaSPMoTaChiTietKoDau = 'MoTaChiTietKoDau';
const String columnDmMoTaSPDonViTinh = 'DonViTinh';
const String columnDmMoTaSPMaVSIC = 'MaVSIC';
const String columnDmMoTaSPTenVSIC = 'TenVSIC';
const String columnDmMoTaSPMaLV = 'MaLV';
const String columnDmMoTaSPTenLinhVuc = 'TenLinhVuc';


const String tableDmMoTaSanPhamVirtual = 'CT_DM_MoTaSanPhamVirtual';

class TableDmMotaSanpham {
  int? id;
  String? maSanPham;
  String? tenSanPham;
  String? tenSanPhamKoDau;
  String? moTaChiTiet;
  String? moTaChiTietKoDau;
  String? donViTinh;
  String? maVSIC;
  String? tenVSIC;
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
      this.maVSIC,
      this.tenVSIC,
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
    maVSIC = json['MaVSIC'];
    tenVSIC = json['TenVSIC'];
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
    data['MaVSIC'] = maVSIC;
    data['TenVSIC'] = tenVSIC;
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

class TableDmMotaSanphamVirtual { 
  String? maSanPham;
  String? tenSanPham;
  String? tenSanPhamKoDau;
  String? moTaChiTiet;
  String? moTaChiTietKoDau; 

  TableDmMotaSanphamVirtual(
      { 
      this.maSanPham,
      this.tenSanPham,
      this.tenSanPhamKoDau,
      this.moTaChiTiet,
      this.moTaChiTietKoDau,
      });

  TableDmMotaSanphamVirtual.fromJson(Map json) { 
    maSanPham = json['MaSanPham'];
    tenSanPham = json['TenSanPham'];
    tenSanPhamKoDau = json['TenSanPhamKoDau'];
    moTaChiTiet = json['MoTaChiTiet'];
    moTaChiTietKoDau = json['MoTaChiTietKoDau']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaSanPham'] = maSanPham;
    data['TenSanPham'] = tenSanPham;
    data['TenSanPhamKoDau'] = tenSanPhamKoDau;
    data['MoTaChiTiet'] = moTaChiTiet;
    data['MoTaChiTietKoDau'] = moTaChiTietKoDau; 
    return data;
  }

  static List<TableDmMotaSanphamVirtual> listFromJson(dynamic localities) {
    List<TableDmMotaSanphamVirtual> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmMotaSanphamVirtual.fromJson(item));
      }
    }
    return list;
  }
}
