///Danh mục mô tả sản phẩm
class DmMotaSanphamModel {
  String? maSanPham;
  String? tenSanPham;
  String? tenSanPhamKoDau;
  String? moTaChiTiet;
  String? moTaChiTietKoDau;
  String? donViTinh;
  String? maLV;
  String? tenLinhVuc;

  DmMotaSanphamModel(
      {this.maSanPham,
      this.tenSanPham,
      this.tenSanPhamKoDau,
      this.moTaChiTiet,
      this.moTaChiTietKoDau,
      this.donViTinh,
      this.maLV,
      this.tenLinhVuc});

  DmMotaSanphamModel.fromJson(dynamic json) {
    maSanPham = json['MaSanPham'];
    tenSanPham = json['TenSanPham'];
    tenSanPhamKoDau = json['TenSanPhamKoDau'];
    moTaChiTiet = json['MoTaChiTiet'];
    moTaChiTietKoDau = json['MoTaChiTietKoDau'];
    donViTinh = json['DonViTinh'];
    maLV = json['MaLV'];
    tenLinhVuc = json['TenLinhVuc'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaSanPham'] = maSanPham;
    map['TenSanPham'] = tenSanPham;
    map['TenSanPhamKoDau'] = tenSanPhamKoDau;
    map['MoTaChiTiet'] = moTaChiTiet;
    map['MoTaChiTietKoDau'] = moTaChiTietKoDau;
    map['DonViTinh'] = donViTinh;
    map['MaLV'] = maLV;
    map['TenLinhVuc'] = tenLinhVuc;
    return map;
  }

  static List<DmMotaSanphamModel> listFromJson(dynamic json) {
    List<DmMotaSanphamModel> list = [];
    if (json != null) {
      for (var value in json) {
        list.add(DmMotaSanphamModel.fromJson(value));
      }
    }
    return list;
  }
}
