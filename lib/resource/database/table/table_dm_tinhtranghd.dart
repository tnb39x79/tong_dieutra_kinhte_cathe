const String tableDmTinhTrangHD = 'DmTinhTrangHD'; 
const String columnDmTinhTrangHDId = '_id';
const String columnDmTinhTrangHDMaTinhTrang = 'MaTinhTrang';
const String columnDmTinhTrangHDTenTinhTrang = 'TenTinhTrang';

///MaPhieu=MaDoiTuongDT=Mã đối tượng điều tra
const String columnDmTinhTrangHDMaDoiTuongDT = 'MaDoiTuongDT'; 

class TableDmTinhTrangHD {
  int? id;
  int? maTinhTrang;
  String? tenTinhTrang;
  int? maDoiTuongDT; 

  TableDmTinhTrangHD({
    this.id,
    this.maTinhTrang,
    this.tenTinhTrang,
    this.maDoiTuongDT 
  });

  TableDmTinhTrangHD.fromJson(Map json) {
    id = json['_id'];
    maTinhTrang = json['MaTinhTrang'];
    tenTinhTrang = json['TenTinhTrang'];
    maDoiTuongDT = json['MaDoiTuongDT']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaTinhTrang'] = maTinhTrang;
    data['TenTinhTrang'] = tenTinhTrang;
    data['MaDoiTuongDT'] = maDoiTuongDT; 
    return data;
  }

  static List<TableDmTinhTrangHD> listFromJson(dynamic localities) {
    List<TableDmTinhTrangHD> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmTinhTrangHD.fromJson(item));
      }
    }
    return list;
  }
}
