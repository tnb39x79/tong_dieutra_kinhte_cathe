import 'dart:ffi';

import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class QuestionFieldModel {
  int? manHinh;
  String? maCauHoi;
  String? tenNganCauHoi;
  String? mucCauHoi;
  String? tenTruong;
  int? loaiCauHoi;
  double? giaTriNN;
  double? giaTriLN;
  String? bangDuLieu;
  String? bangChiTieu;
  String? tenTruongKhoa;
  String? maIODinhDanh;
  String? dieuKienMaIO;
  //Câu hỏi cha là loại 1 (có/không) để nhận biết khi validate giá trị câu hỏi con nếu câu hỏi cha có giá trị =1 mới validate con hỏi con, =0 không gọi validate
  
  QuestionCommonModel? question;
  ChiTieuModel? chiTieuCot;
  ChiTieuDongModel? chiTieuDong;

  QuestionFieldModel(
      {this.manHinh,
      this.maCauHoi,
      this.tenNganCauHoi,
      this.mucCauHoi,
      this.tenTruong,
      this.loaiCauHoi,
      this.giaTriNN,
      this.giaTriLN,
      this.bangDuLieu,
      this.bangChiTieu,
      this.tenTruongKhoa,
      this.maIODinhDanh,
      this.dieuKienMaIO,
      this.question,
      this.chiTieuCot,
      this.chiTieuDong});

  QuestionFieldModel.fromJson(dynamic json) {
    manHinh = json['ManHinh'];
    maCauHoi = json['MaCauHoi'];
    tenNganCauHoi = json['TenNganCauHoi'];
    mucCauHoi = json['MucCauHoi'];
    tenTruong = json['TenTruong'];
    loaiCauHoi = json['LoaiCauHoi'];

    giaTriNN = json['GiaTriNN'];
    giaTriLN = json['GiaTriLN'];
    bangDuLieu = json['BangDuLieu'];
    bangChiTieu = json['BangChiTieu'];
    tenTruongKhoa = json['TenTruongKhoa'];
   maIODinhDanh = json['MaIODinhDanh'];
    dieuKienMaIO = json['DieuKienMaIO'];
    question = json['Question'];
    chiTieuCot = json['ChiTieuCot'];
    chiTieuDong = json['ChiTieuDong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ManHinh'] = manHinh;
    data['MaCauHoi'] = maCauHoi;
    data['TenNganCauHoi'] = tenNganCauHoi;
    data['MucCauHoi'] = mucCauHoi;
    data['TenTruong'] = tenTruong;
    data['LoaiCauHoi'] = loaiCauHoi;

    data['GiaTriNN'] = giaTriNN;
    data['GiaTriLN'] = giaTriLN;
    data['BangDuLieu'] = bangDuLieu;
    data['BangChiTieu'] = bangChiTieu;
    data['TenTruongKhoa'] = tenTruongKhoa;
    data['MaIODinhDanh'] = maIODinhDanh;
    data['DieuKienMaIO'] = dieuKienMaIO;
    data['question'] = question;
    data['ChiTieuCot'] = chiTieuCot;
    data['ChiTieuDong'] = chiTieuDong;

    return data;
  }

  static List<QuestionCommonModel> listFromJson(dynamic json) {
    List<QuestionCommonModel> list = [];
    if (json != null) {
      for (var item in json) {
        list.add(QuestionCommonModel.fromJson(item));
      }
    }
    return list;
  }
}
