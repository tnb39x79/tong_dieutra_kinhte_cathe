///XacNhanLogic
const String tableXacNhanLogic = 'XacNhanLogic'; 
const String columnXnLogicId = '_id';
const String columnXnLogicMaDTV = 'MaDTV';
const String columnXnLogicManHinh = 'ManHinh';

/// IdCoSo: MaDoiTuongDT = 4 hoặc IdHo: MaDoiTuongDT= 5
const String columnXnLogicIdDoiTuong = 'IdDoiTuong';
const String columnXnLogicMaDoiTuongDT = 'MaDoiTuongDT';

///0: Chưa hết logic; 1: Đã hết logic
const String columnXnLogicIsLogic = 'IsLogic';
const String columnXnLogicIsEnableMenuItem = 'IsEnableMenuItem';
const String columnXnLogicNoiDungLogic = 'NoiDungLogic';
const String columnXnLogicMaTrangThaiDT = 'MaTrangThaiDT';

class TableXacnhanLogic {
  int? id;
  String? maDTV;
  int? manHinh;
  String? idDoiTuong;
  int? maDoiTuongDT;
  int? isLogic;
  int? isEnableMenuItem;
  String? noiDungLogic;
  int? maTrangThaiDT;

  TableXacnhanLogic(
      {this.id,
      this.maDTV,
      this.manHinh,
      this.idDoiTuong,
      this.maDoiTuongDT,
      this.isLogic,
      this.isEnableMenuItem,
      this.noiDungLogic,
      this.maTrangThaiDT});

  TableXacnhanLogic.fromJson(Map json) {
    id = json['_id'];
    maDTV = json['MaDTV'];
    manHinh = json['ManHinh'];
    idDoiTuong = json['IdDoiTuong'];
    maDoiTuongDT = json['MaDoiTuongDT'];
    isLogic = json['IsLogic'];
    isEnableMenuItem = json['IsEnableMenuItem'];
    noiDungLogic = json['NoiDungLogic'];
    maTrangThaiDT = json['MaTrangThaiDT'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['MaDTV'] = maDTV;
    data['ManHinh'] = manHinh;
    data['IdDoiTuong'] = idDoiTuong;
    data['MaDoiTuongDT'] = maDoiTuongDT;
    data['IsLogic'] = isLogic;
    data['IsEnableMenuItem'] = isEnableMenuItem;
    data['NoiDungLogic'] = noiDungLogic;
    data['MaTrangThaiDT'] = maTrangThaiDT;
    return data;
  }

  static List<TableXacnhanLogic> listFromJson(dynamic localities) {
    List<TableXacnhanLogic> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableXacnhanLogic.fromJson(item));
      }
    }
    return list;
  }
}
