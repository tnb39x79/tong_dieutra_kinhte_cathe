const String tableDoiTuongDT = 'DoiTuongDieuTra';
const String columnDoiTuongDTId = '_id';
const String columnDoiTuongDTMaDoiTuongDT = 'MaDoiTuongDT';
const String columnDoiTuongDTTenDoiTuongDT = 'TenDoiTuongDT';
const String columnDoiTuongDTMoTaDoiTuongDT = 'MoTaDoiTuongDT';
const String columnDoiTuongDTTenPhieuCapi = 'TenPhieuCapi';

class TableDoiTuongDieuTra {
  int? id;
  int? maDoiTuongDT;
  String? tenDoiTuongDT;
  String? moTaDoiTuongDT; 

  TableDoiTuongDieuTra(
      {this.id,
      this.maDoiTuongDT,
      this.tenDoiTuongDT,
      this.moTaDoiTuongDT });

  TableDoiTuongDieuTra.fromJson(Map json) {
    id = json['_id'];
    maDoiTuongDT = json['MaDoiTuongDT'];
    tenDoiTuongDT = json['TenDoiTuongDT'];
    moTaDoiTuongDT = json['MoTaDoiTuongDT']; 
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaDoiTuongDT'] = maDoiTuongDT;
    data['TenDoiTuongDT'] = tenDoiTuongDT;
    data['MoTaDoiTuongDT'] = moTaDoiTuongDT; 
    return data;
  }

  static List<TableDoiTuongDieuTra> listFromJson(dynamic localities) {
    List<TableDoiTuongDieuTra> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDoiTuongDieuTra.fromJson(item));
      }
    }
    return list;
  }
}
