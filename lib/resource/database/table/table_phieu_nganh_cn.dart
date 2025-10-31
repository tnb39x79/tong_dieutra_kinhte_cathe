import 'table_p07mau.dart';

const String tablePhieuNganhCN = 'CT_Phieu_NganhCN';

const String colPhieuNganhCNId = '_id';
const String colPhieuNganhCNIDCoSo = 'IDCoSo';
const String colPhieuNganhCNSTT_SanPham = 'STT_SanPham';
const String colPhieuNganhCNMaNganhC5 = 'MaNganhC5';
const String colPhieuNganhCNA1_1 = 'A1_1';
const String colPhieuNganhCNA1_2 = 'A1_2';
const String colPhieuNganhCNA2_1 = 'A2_1';
const String colPhieuNganhCNA2_2 = 'A2_2';

//const String colPhieuNganhCNLoaiDvt = 'LoaiDvt';
const String colPhieuNganhCNIsDefault = 'IsDefault';
const String colPhieuNganhCNIsSync = 'IsSync';
const String colPhieuNganhCNCreatedAt = 'CreatedAt';
const String colPhieuNganhCNUpdatedAt = 'UpdatedAt';

class TablePhieuNganhCN {
  int? id;
  String? iDCoSo;
  int? sTT_SanPham;
  String? maNganhC5;
  String? a1_1;
  String? a1_2;
  String? a2_1;
  double? a2_2;

  ///1: Đơn vị tính lấy từ danh mục sản phẩm;
  ///2: Đơn vị tính người dùng tự nhập
  // int? loaiDvt;
 
  int? isDefault;
  int? isSync;
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhCN(
      {this.id,
      this.iDCoSo,
      this.sTT_SanPham,
      this.maNganhC5,
      this.a1_1,
      this.a1_2,
      this.a2_1,
      this.a2_2,
      //    this.loaiDvt,
     
      this.isDefault,
      this.isSync,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhCN.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTT_SanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];

    a1_1 = json['A1_1'];
    a1_2 = json['A1_2'];
    a2_1 = json['A2_1'];
    a2_2 = json['A2_2'];

    //  loaiDvt = json['LoaiDvt'];
    
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
    json['STT_SanPham'] = sTT_SanPham;
    json['MaNganhC5'] = maNganhC5;
    json['A1_1'] = a1_1;
    json['A1_2'] = a1_2;
    json['A2_1'] = a2_1;
    json['A2_2'] = a2_2;
    // json['LoaiDvt'] = loaiDvt;
    
    json['IsDefault'] = isDefault;
    json['IsSync'] = isSync;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

    Map<String, Object?> toJsonGetDLPV() {
    var json = <String, Object?>{}; 

    json['IDCoSo'] = iDCoSo;
    json['STT_SanPham'] = sTT_SanPham;
    json['MaNganhC5'] = maNganhC5;
    json['A1_1'] = a1_1;
    json['A1_2'] = a1_2;
    json['A2_1'] = a2_1;
    json['A2_2'] = a2_2;
    // json['LoaiDvt'] = loaiDvt;
    
    json['IsDefault'] = isDefault;
    json['IsSync'] = isSync;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt; 
    return json;
  }

  static List<TablePhieuNganhCN>? fromListJson(dynamic json) {
    List<TablePhieuNganhCN> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhCN.fromJson(item));
      }
    }
    return list;
  }
}

class TablePhieuNganhCNCap5 {
  int? id;
  String? iDCoSo;
  int? sTT_SanPham;
  String? maNganhC5;
  String? moTaSanPham;
  String? a1_1;
  String? a1_2;
  String? a2_1;
  double? a2_2;

  int? isDefault;
  int? isSync;
  String? maDTV;
  String? createdAt;
  String? updatedAt;

  TablePhieuNganhCNCap5(
      {this.id,
      this.iDCoSo,
      this.sTT_SanPham,
      this.maNganhC5,
      this.moTaSanPham,
      this.a1_1,
      this.a1_2,
      this.a2_1,
      this.a2_2,
      this.isDefault,
      this.isSync,
      this.maDTV,
      this.createdAt,
      this.updatedAt});

  TablePhieuNganhCNCap5.fromJson(dynamic json) {
    id = json['_id'];
    iDCoSo = json['IDCoSo'];
    sTT_SanPham = json['STT_SanPham'];
    maNganhC5 = json['MaNganhC5'];
    moTaSanPham = json['MoTaSanPham'];
    a1_1 = json['A1_1'];
    a1_2 = json['A1_2'];
    a2_1 = json['A2_1'];
    a2_2 = json['A2_2'];

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
    json['STT_SanPham'] = sTT_SanPham;
    json['MaNganhC5'] = maNganhC5;
    json['MoTaSanPham'] = moTaSanPham;
    json['A1_1'] = a1_1;
    json['A1_2'] = a1_2;
    json['A2_1'] = a2_1;
    json['A2_2'] = a2_2;
    json['IsDefault'] = isDefault;
    json['IsSync'] = isSync;
    json['MaDTV'] = maDTV;
    json['CreatedAt'] = createdAt;
    json['UpdatedAt'] = updatedAt;
    return json;
  }

  static List<TablePhieuNganhCNCap5>? fromListJson(dynamic json) {
    List<TablePhieuNganhCNCap5> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(TablePhieuNganhCNCap5.fromJson(item));
      }
    }
    return list;
  }
}
