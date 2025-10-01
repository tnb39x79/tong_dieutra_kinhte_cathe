import 'dart:developer';
import 'dart:ffi';

import 'package:gov_statistics_investigation_economic/common/utils/app_utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class QuestionMenuModel {
  int? maPhieu;
  String? maCauHoi;
  int? manHinh;
  String? maCauHoiCha;
  String? tenCauHoi;
  int? sTT;
  String? maSo;
  int? cap;
  int? loaiCauHoi;
  String? bangChiTieu;
  String? bangDuLieu;

  QuestionMenuModel(
      {this.maPhieu,
      this.maCauHoi,
      this.manHinh,
      this.maCauHoiCha,
      this.tenCauHoi,
      this.sTT,
      this.maSo,
      this.cap,
      this.loaiCauHoi,
      this.bangChiTieu,
      this.bangDuLieu});

  QuestionMenuModel.fromJson(dynamic json) {
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    manHinh = json['ManHinh'];
    maCauHoiCha = json['MaCauHoiCha'];
    tenCauHoi = json['TenCauHoi'];
    sTT = json['STT'];
    maSo = json['MaSo'];
    cap = json['Cap'];
    loaiCauHoi = json['LoaiCauHoi'];
    bangChiTieu = json['BangChiTieu'];
    bangDuLieu = json['BangDuLieu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MaPhieu'] = maPhieu;
    data['MaCauHoi'] = maCauHoi;
    data['ManHinh'] = manHinh;
    data['MaCauHoiCha'] = maCauHoiCha;
    data['TenCauHoi'] = tenCauHoi;
    data['STT'] = sTT;
    data['MaSo'] = maSo;
    data['Cap'] = cap;
    data['LoaiCauHoi'] = loaiCauHoi;
    data['BangChiTieu'] = bangChiTieu;
    data['BangDuLieu'] = bangDuLieu;
    return data;
  }

  static List<QuestionMenuModel> listFromJson(dynamic json) {
    List<QuestionMenuModel> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(QuestionMenuModel.fromJson(item));
      }
    }
    return list;
  }
}
