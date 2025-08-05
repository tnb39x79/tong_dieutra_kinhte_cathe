 
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_tongiao.dart';

///Danh mục địa bàn hộ CT_DM_DiaBanCoSoTonGiao
const String tableDiaBanTonGiao = 'DmDiaBanTonGiao'; 

const String columnDmDiaBanTonGiaoId = '_id';
const String columnDmDiaBanTonGiaoMaTinh = 'MaTinh';
const String columnDmDiaBanTonGiaoMaHuyen = 'MaHuyen';
const String columnDmDiaBanTonGiaoMaXa = 'MaXa';
const String columnDmDiaBanTonGiaoTenXa = 'TenXa';  
const String columnDmDiaBanTonGiaoMaDTV = 'MaDTV';
const String columnDmDiaBanTonGiaoCreatedAt = 'CreatedAt';
const String columnDmDiaBanTonGiaoUpdatedAt = 'UpdatedAt';

class TableDmDiaBanTonGiao {
  int? id;
 // int? nam;
  String? maTinh;
  String? maHuyen;
  String? maXa;
  //String? maDiaBan;
  String? tenXa;
  String? maDTV;
  String? createdAt;
  String? updatedAt;
  List<TableBkTonGiao>? tableBkTonGiao;

  TableDmDiaBanTonGiao({
   
    this.maTinh,
    this.maHuyen,
    this.maXa,
  //  this.maDiaBan,
    this.tenXa,
    this.maDTV,
    this.createdAt,
    this.updatedAt,
    this.tableBkTonGiao,
  });

  TableDmDiaBanTonGiao.fromJson(dynamic json) {
    id = json['_id'];
   
    maTinh = json['MaTinh'];
    maHuyen = json['MaHuyen'];
    maXa = json['MaXa'];
  //  maDiaBan = json['MaDiaBan'];
    tenXa = json['TenXa'];
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'] ?? DateTime.now().toIso8601String();
    updatedAt = json['UpdatedAt'] ?? DateTime.now().toIso8601String();
    tableBkTonGiao = json['DanhSachBKCoSoTonGiao'] != null
        ? TableBkTonGiao.listFromJson(json['DanhSachBKCoSoTonGiao'])
        : null;
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> data = <String, Object?>{};
    
    data['MaTinh'] = maTinh;
    data['MaHuyen'] = maHuyen;
    data['MaXa'] = maXa;
  //  data['MaDiaBan'] = maDiaBan;
    data['TenXa'] = tenXa;
    data['MaDTV'] = maDTV;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }
}
