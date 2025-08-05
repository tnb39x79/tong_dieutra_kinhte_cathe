const String tableDmLinhVuc = 'DmLinhVuc';
const String columnDmLinhVucId = '_id';
const String columnDmLinhVucMaLV = 'MaLV';
const String columnDmLinhVucTenLinhVuc = 'TenLinhVuc';

class TableDmLinhvuc {
  int? id;
  String? maLV;
  String? tenLinhVuc;

  TableDmLinhvuc({this.id, this.maLV, this.tenLinhVuc});
  factory TableDmLinhvuc.defaultLinhVuc() {
    TableDmLinhvuc defaultSelected =
        TableDmLinhvuc(id: 0, maLV: '0', tenLinhVuc: "Chọn lĩnh vực");

    return defaultSelected;
  }
  TableDmLinhvuc.fromJson(Map json) {
    id = json['_id'];
    maLV = json['MaLV'];
    tenLinhVuc = json['TenLinhVuc'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaLV'] = maLV;
    data['TenLinhVuc'] = tenLinhVuc;
    return data;
  }

  static List<TableDmLinhvuc> listFromJson(dynamic localities) {
    List<TableDmLinhvuc> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmLinhvuc.fromJson(item));
      }
    }
    return list;
  }

  bool operator ==(o) => o is TableDmLinhvuc && o.tenLinhVuc == tenLinhVuc && o.maLV == maLV;
}
