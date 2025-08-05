import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_bkcoso_sxkd_nganh_sanpham.dart';

///Danh mục địa bàn(xã/phường thị trấn) cho cơ sở sản xuất kinh
const String tableDiaBanCoSoSXKD = 'DmDiaBanCoSoSXKD';
const String columnDmDiaBanCoSoSxkdId = '_id';
const String columnDmDiaBanCoSoSxkdMaPhieu = 'MaPhieu';
const String columnDmDiaBanCoSoSxkdMaTinh = 'MaTinh';
const String columnDmDiaBanCoSoSxkdMaHuyen = 'MaHuyen';
const String columnDmDiaBanCoSoSxkdMaXa = 'MaXa';
const String columnDmDiaBanCoSoSxkdMaDiaBan = 'MaDiaBan';
const String columnDmDiaBanCoSoSxkdTenDiaBan = 'TenDiaBan';

const String columnDmDiaBanCoSoMaDTV = 'MaDTV';
const String columnDmDiaBanCoSoCreatedAt = 'CreatedAt';
const String columnDmDiaBanCoSoUpdatedAt = 'UpdatedAt';

class TableDmDiaBanCosoSxkd {
  int? id;
  int? maPhieu;
  String? maTinh;
  String? maHuyen;
  String? maXa;
  String? maDiaBan;
  String? tenDiaBan;
  String? maDTV;
  String? createdAt;
  String? updatedAt;
  List<TableBkCoSoSXKD>? tablebkCoSoSXKD;

  TableDmDiaBanCosoSxkd(
      {this.maPhieu,
      this.maTinh,
      this.maHuyen,
      this.maXa,
      this.maDiaBan,
      this.tenDiaBan,
      this.maDTV,
      this.createdAt,
      this.updatedAt,
      this.tablebkCoSoSXKD});

  TableDmDiaBanCosoSxkd.fromJson(dynamic json) {
    id = json['_id'];
    maPhieu = json['MaPhieu'];
    maTinh = json['MaTinh'];
    maHuyen = json['MaHuyen'];
    maXa = json['MaXa'];
    maDiaBan = json['MaDiaBan'];
    tenDiaBan = json['TenDiaBan'];
    maDTV = json['MaDTV'];
    createdAt = json['CreatedAt'] ?? DateTime.now().toIso8601String();
    updatedAt = json['UpdatedAt'] ?? DateTime.now().toIso8601String();
    tablebkCoSoSXKD = json['DanhSachBKCoSoSXKD'] != null
        ? TableBkCoSoSXKD.listFromJson(json['DanhSachBKCoSoSXKD'])
        : null;
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> data = <String, Object?>{};
    data['MaPhieu'] = maPhieu;
    data['MaTinh'] = maTinh;
    data['MaHuyen'] = maHuyen;
    data['MaXa'] = maXa;
    data['MaDiaBan'] = maDiaBan;
    data['TenDiaBan'] = tenDiaBan;
    data['MaDTV'] = maDTV;
    data['CreatedAt'] = createdAt;
    data['UpdatedAt'] = updatedAt;
    return data;
  }
}
