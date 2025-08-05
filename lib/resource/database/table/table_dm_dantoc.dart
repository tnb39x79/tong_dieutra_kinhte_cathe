const String tableDmDanToc = 'KT_DM_DanToc';
const String columnDmDanTocId = '_id';
const String columnDmDanTocMaDanToc = 'MaDanToc';
const String columnDmDanTocTenDanToc = 'TenDanToc';
const String columnDmDanTocTenGoiKhac = 'TenGoiKhac';
const String columnDmDanTocSTT = 'STT';

class TableDmDanToc {
  int? id;
  String? maDanToc;
  String? tenDanToc;
  String? tenGoiKhac;
  int? stt;

  TableDmDanToc({this.id, this.maDanToc, this.tenDanToc,this.tenGoiKhac, this.stt});

  TableDmDanToc.fromJson(Map json) {
    id = json['_id'];
    maDanToc = json['MaDanToc'];
    tenDanToc = json['TenDanToc'];
    tenGoiKhac = json['TenGoiKhac'];
    stt = json['STT'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaDanToc'] = maDanToc;
    data['TenDanToc'] = tenDanToc;
    data['TenGoiKhac'] = tenGoiKhac;
    data['STT'] = stt;
    return data;
  }

  static List<TableDmDanToc> listFromJson(dynamic localities) {
    List<TableDmDanToc> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableDmDanToc.fromJson(item));
      }
    }
    return list;
  }
}
