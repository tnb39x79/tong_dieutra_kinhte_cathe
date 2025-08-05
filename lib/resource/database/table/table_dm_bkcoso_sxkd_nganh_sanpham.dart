const String tableBkCoSoSXKDNganhSanPham = 'DmBkCoSoSXKD_NganhSanPham'; 
const String columnBkCoSoSXKDNganhSanPhamId = '_id';
const String columnBkCoSoSXKDNganhSanPhamIDCoSo = 'IDCoSo';
const String columnBkCoSoSXKDNganhSanPhamMaNganh = 'MaNganh';
const String columnBkCoSoSXKDNganhSanPhamTenNganh= 'TenNganh';  

class TableBkCoSoSXKDNganhSanPham {
  int? id;
  String? idCoSo;
  String? maNganh;   
  String? tenNganh;   

  TableBkCoSoSXKDNganhSanPham({
    this.id,
    this.idCoSo,
    this.maNganh,
    this.tenNganh
  });

  TableBkCoSoSXKDNganhSanPham.fromJson(Map json) {
    id = json['_id'];
    idCoSo = json['IDCoSo'];
    maNganh = json['MaNganh'];
    tenNganh = json['TenNganh']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['IDCoSo'] = idCoSo;
    data['MaNganh'] = maNganh;  
     data['TenNganh'] = tenNganh;  
    return data;
  }
 

  static List<TableBkCoSoSXKDNganhSanPham> listFromJson(dynamic json) {
    List<TableBkCoSoSXKDNganhSanPham> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TableBkCoSoSXKDNganhSanPham.fromJson(item));
      }
    }
    return list;
  }
}
