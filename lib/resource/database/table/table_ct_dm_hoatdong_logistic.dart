import 'package:gov_statistics_investigation_economic/resource/resource.dart';

const String tableCTDmHoatDongLogistic = 'CT_DM_HoatDongLogistic';
const String columnCTDmHoatDongLigisticId = '_id';
const String columnCTDmHoatDongLigisticMa = 'Ma';
const String columnCTDmHoatDongLigisticTen = 'Ten';

class TableCTDmHoatDongLogistic {
  int? id;
  int? ma;
  String? ten;

  TableCTDmHoatDongLogistic({this.id, this.ma, this.ten});

  TableCTDmHoatDongLogistic.fromJson(Map json) {
    id = json['_id'];
    ma = json['Ma'];
    ten = json['Ten'];
  }

  Map<String, Object?> toJson() {
    final data = <String, Object?>{};
    data['Ma'] = ma;
    data['Ten'] = ten;
    return data;
  }

  static List<ChiTieuIntModel> toListChiTieuIntModel(
      List<TableCTDmHoatDongLogistic> dmHoatDongLogistic) {
    List<ChiTieuIntModel> chiTieuIntModels = [];
    for (var item in dmHoatDongLogistic) {
      ChiTieuIntModel chiTieuIntModel =
          ChiTieuIntModel(maChiTieu: item.ma, tenChiTieu: item.ten);
      chiTieuIntModels.add(chiTieuIntModel);
    }
    return chiTieuIntModels;
  }

  static List<TableCTDmHoatDongLogistic> listFromJson(dynamic localities) {
    List<TableCTDmHoatDongLogistic> list = [];
    if (localities != null) {
      for (var item in localities) {
        list.add(TableCTDmHoatDongLogistic.fromJson(item));
      }
    }
    return list;
  }
}
