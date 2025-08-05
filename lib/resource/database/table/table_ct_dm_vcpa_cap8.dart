

///Tên bảng ở DB: CT_DM_NganhSanPham_C8
const String tableCTDmVcpaCap8 = 'CT_DmVcpaCap8';
const String columnCTDmVcpaCap8Id = '_id';
const String columnCTDmVcpaCap8Cap5 = 'Cap5';
const String columnCTDmVcpaCap8Cap8 = 'Cap8';
const String columnCTDmVcpaCap8TenSP = 'TenSanpham';
const String columnCTDmVcpaCap8DVT = 'DVT';


class TableCTDmVcpaCap8 {
  int? id;
  String? cap5;
  String? cap8;
  String? tenSanPham;
  String? dvt; 

  TableCTDmVcpaCap8({
    this.id,
    this.cap5,
    this.cap8,
    this.tenSanPham,
    this.dvt 
  });

  TableCTDmVcpaCap8.fromJson(Map json) {
    id = json['_id'];
    cap5 = json['Cap5'];
    cap8 = json['Cap8'];
    tenSanPham = json['TenSanpham'];
    dvt = json['Donvitinh']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Cap5'] = cap5;
    data['Cap8'] = cap8;
    data['TenSanpham'] = tenSanPham;
    data['Donvitinh'] = dvt; 
    return data;
  }

  static List<TableCTDmVcpaCap8> listFromJson(dynamic localities) {
    List<TableCTDmVcpaCap8> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmVcpaCap8.fromJson(item));
      }
    }
    return list;
  }
}
