import 'table_p07mau.dart';

const String tablePhieuMauTBSanPham = 'CT_Phieu_MauTB_SanPham';

const String tablePhieuMauTBSanPhamID = '_id';
const String colPhieuMauTBSanPhamIDCoSo = 'IDCoSo';
const String colPhieuMauTBSanPhamSTTSanPham = 'STT_SanPham';
const String colPhieuMauTBSanPhamMaNganhC5 = 'MaNganhC5';
const String colPhieuMauTBSanPhamA5_1_1 = 'A5_1_1';
const String colPhieuMauTBSanPhamA5_1_2 = 'A5_1_2';
const String colPhieuMauTBSanPhamA5_2 = 'A5_2';

const String columnPhieuMauSanPhamDefault = 'IsDefault';
const String columnPhieuMauSanPhamIsSync = 'IsSync';
const String colPhieuMauTBSanPhamCreatedAt = 'CreatedAt';
const String colPhieuMauTBSanPhamUpdatedAt = 'UpdatedAt';

class TablePhieuMauTBSanPham {
  int? id;
  String? iDCoSo;
  int? sTTSanPham;
  String? maNganhC5;
  String? a5_1_1;
  String? a5_1_2;
  double? a5_2;

  int? isDefault;
  int? isSync;

  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuMauTBSanPham(
      {this.id,
      this.iDCoSo,
      this.sTTSanPham,
      this.maNganhC5,
      this.a5_1_1,
      this.a5_1_2,
      this.a5_2,
      this.isDefault,
      this.isSync,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuMauTBSanPham.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTTSanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    a5_1_1 = json['A5_1_1'];
    a5_1_2 = json['A5_1_2'];
    a5_2 = json['A5_2'];

    isDefault = json['IsDefault'];
    isSync = json['IsSync'];
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
  }

  Map<String, Object?> toJson() {
    var json = <String, Object?>{};
    json['_id'] = id;

    json['IDCoSo'] = iDCoSo;
    json['STT_SanPham'] = sTTSanPham;
    json['MaNganhC5'] = maNganhC5;
    json['A5_1_1'] = a5_1_1;
    json['A5_1_2'] = a5_1_2;
    json['A5_2'] = a5_2;

    json['IsDefault'] = isDefault;
    json['IsSync'] = isSync;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuMauTBSanPham>? fromListJson(dynamic json) {
    List<TablePhieuMauTBSanPham> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuMauTBSanPham.fromJson(item));
      }
    }
    return list;
  }

  static final vcpaCap5Range47811To47899 = [
    '47811',
    '47812',
    '47813',
    '47814',
    '47815',
    '47816',
    '47817',
    '47818',
    '47819',
    '47821',
    '47822',
    '47823',
    '47830',
    '47841',
    '47842',
    '47843',
    '47850',
    '47891',
    '47892',
    '47893',
    '47894',
    '47895',
    '47896',
    '47897',
    '47898',
    '47899'
  ];

  ///Loại trừ mã 45200 và 45420
  static final vcpaCap5Range45111To46900 = [
    '45111',
    '45119',
    '45120',
    '45131',
    '45139',
    '45301',
    '45302',
    '45303',
    '45411',
    '45412',
    '45413',
    '45431',
    '45432',
    '45433',
    '46101',
    '46102',
    '46103',
    '46201',
    '46202',
    '46203',
    '46204',
    '46209',
    '46310',
    '46321',
    '46322',
    '46323',
    '46324',
    '46325',
    '46326',
    '46329',
    '46331',
    '46332',
    '46340',
    '46411',
    '46412',
    '46413',
    '46414',
    '46491',
    '46492',
    '46493',
    '46494',
    '46495',
    '46496',
    '46497',
    '46498',
    '46499',
    '46510'
  ];

  static final vcpaCap5Range86101To86990 = [
    '86201',
    '86202',
    '86910',
    '86920',
    '86990'
  ];

  static final vcpaCap5Range71101To71109 = ['71101', '71102', '71103', '71109'];

  static final vcpaCap2CN10To39 = [
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39'
  ];
}
