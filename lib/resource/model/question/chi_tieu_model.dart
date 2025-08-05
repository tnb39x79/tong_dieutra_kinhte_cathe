import 'dart:developer';

import 'package:gov_statistics_investigation_economic/common/utils/app_utils.dart';

class ChiTieuIntModel {
  int? maChiTieu;
  String? tenChiTieu;

  ChiTieuIntModel({
    this.maChiTieu,
    this.tenChiTieu,
  });

  ChiTieuIntModel.fromJson(dynamic json) {
    maChiTieu = json['MaChiTieu'];
    tenChiTieu = json['TenChiTieu'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaChiTieu'] = maChiTieu;
    map['TenChiTieu'] = tenChiTieu;
    return map;
  }
}

class ChiTieuModel {
  int? maPhieu;
  String? maCauHoi;
  String? maChiTieu;
  String? tenChiTieu;
  int? sTT;
  int? loaiChiTieu;
  int? loaiCauHoi;
  double? giaTriNN;
  double? giaTriLN;
  String? dVT;
  String? tenTruong;

  ChiTieuModel(
      {this.maPhieu,
      this.maCauHoi,
      this.maChiTieu,
      this.tenChiTieu,
      this.sTT,
      this.loaiChiTieu,
      this.loaiCauHoi,
      this.giaTriNN,
      this.giaTriLN,
      this.dVT,
      this.tenTruong});

  ChiTieuModel.fromJson(dynamic json) {
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    maChiTieu = json['MaChiTieu'];
    tenChiTieu = json['TenChiTieu'];
    sTT = json['STT'];
    loaiChiTieu = json['LoaiChiTieu'];
    loaiCauHoi = json['LoaiCauHoi'];
    giaTriNN = json['GiaTriNN'];
    giaTriLN = json['GiaTriLN'];
    dVT = json['DVT'];
    tenTruong = json['TenTruong'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaPhieu'] = maChiTieu;
    map['MaCauHoi'] = maCauHoi;
    map['MaChiTieu'] = maChiTieu;
    map['TenChiTieu'] = tenChiTieu;
    map['STT'] = sTT;
    map['LoaiChiTieu'] = loaiChiTieu;
    map['LoaiCauHoi'] = loaiCauHoi;
    map['GiaTriNN'] = giaTriNN;
    map['GiaTriLN'] = giaTriLN;
    map['DVT'] = dVT;
    map['TenTruong'] = tenTruong;
    return map;
  }
}

class ChiTieuDongModel {
  String? chiTieuIOUUID;
  int? maPhieu;
  String? maCauHoi;
  String? tenChiTieu;
  String? maSo; 
  int? sTT;
  int? loaiCauHoi; 
  String? dVT;
   double? giaTriNN;
  double? giaTriLN;

  ///loaiChiTieu=1: Là chỉ tiêu IO
  String? loaiChiTieu;
  String? maCauHoi1;
  ChiTieuDongModel(
      {this.chiTieuIOUUID,
      this.maPhieu,
      this.maCauHoi,
      this.tenChiTieu,
      this.maSo,
      this.sTT, 
      this.loaiCauHoi, 
          this.giaTriNN,
      this.giaTriLN,
      this.dVT,
      this.loaiChiTieu});

  ChiTieuDongModel.fromJson(dynamic json) {
    var appUtils = AppUtils();
    String ctUUID = appUtils.getCustomUniqueId();
    chiTieuIOUUID = ctUUID;
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    tenChiTieu = json['TenChiTieu'];
    maSo = json['MaSo'];
    sTT = json['STT']; 
    loaiCauHoi = json['LoaiCauHoi']; 
     giaTriNN = json['GiaTriNN'];
    giaTriLN = json['GiaTriLN'];
    dVT = json['DVT'];
    loaiChiTieu = json['LoaiChiTieu']; 
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['ChiTieuIOUUID'] = chiTieuIOUUID;
    map['MaPhieu'] = maPhieu;
    map['MaCauHoi'] = maCauHoi;
    map['TenChiTieu'] = tenChiTieu;
    map['MaSo'] = maSo;
    map['STT'] = sTT; 
    map['LoaiCauHoi'] = loaiCauHoi; 
     map['GiaTriNN'] = giaTriNN;
    map['GiaTriLN'] = giaTriLN;
    map['DVT'] = dVT;

    map['LoaiChiTieu'] = loaiChiTieu;
    map['MaCauHoi1'] = maCauHoi1;

    return map;
  }

  static String joinUUID(List<ChiTieuDongModel> chiTieuIOs) {
    if (chiTieuIOs.isNotEmpty) {
      var ss = chiTieuIOs.map((x) => x.chiTieuIOUUID).toList().join('');
      return ss;
    }
    return '';
  }
}

class ChiTieuKhoaModel {
  int? maPhieu;
  String? maCauHoi;
  String? maChiTieuDong;
  String? maChiTieuCot;

  ChiTieuKhoaModel(
      {this.maPhieu, this.maCauHoi, this.maChiTieuDong, this.maChiTieuCot});

  ChiTieuKhoaModel.fromJson(dynamic json) {
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    maChiTieuDong = json['MaChiTieuDong'];
    maChiTieuCot = json['MaChiTieuCot'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaPhieu'] = maPhieu;
    map['MaCauHoi'] = maCauHoi;
    map['MaChiTieuDong'] = maChiTieuDong;
    map['MaChiTieuCot'] = maChiTieuCot;
    return map;
  }
}

class DiaDiemSXKDModel {
  int? maDiaDiem;
  String? tenDiaDiem;

  DiaDiemSXKDModel({this.maDiaDiem, this.tenDiaDiem});

  DiaDiemSXKDModel.fromJson(dynamic json) {
    maDiaDiem = json['MaDiaDiem'];
    tenDiaDiem = json['TenDiaDiem'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['MaDiaDiem'] = maDiaDiem;
    map['TenDiaDiem'] = tenDiaDiem;
    return map;
  }
}

class LogicModel {
  String? tenTruong;
  String? noiDung;

  LogicModel({this.tenTruong, this.noiDung});

  LogicModel.fromJson(dynamic json) {
    tenTruong = json['TenTruong'];
    noiDung = json['NoiDung'];
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['TenTruong'] = tenTruong;
    map['NoiDung'] = noiDung;
    return map;
  }
}
