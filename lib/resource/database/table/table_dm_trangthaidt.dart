const String tableDmTrangThaiDT = 'DmTrangThaiDT'; 
const String columnDmTrangThaiDTId = '_id';
const String columnDmTrangThaiDTMaTrangThaiDT = 'MaTrangThaiDT';
const String columnDmTrangThaiDTTenTrangThaiDT = 'TenTrangThaiDT';  

class TableDmTrangThaiDT {
  int? id;
  int? maTrangThaiDT;
  String? tenTrangThaiDT;  

  TableDmTrangThaiDT({
    this.id,
    this.maTrangThaiDT,
    this.tenTrangThaiDT
  });

  TableDmTrangThaiDT.fromJson(Map json) {
    id = json['_id'];
    maTrangThaiDT = json['MaTrangThaiDT'];
    tenTrangThaiDT = json['TenTrangThaiDT']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaTrangThaiDT'] = maTrangThaiDT;
    data['TenTrangThaiDT'] = tenTrangThaiDT;  
    return data;
  }

  static List<TableDmTrangThaiDT> listFromJson(dynamic localities) {
    List<TableDmTrangThaiDT> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmTrangThaiDT.fromJson(item));
      }
    }
    return list;
  }
}
