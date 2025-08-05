import 'dart:developer';
import 'dart:ffi';

import 'package:gov_statistics_investigation_economic/common/utils/app_utils.dart';
import 'package:gov_statistics_investigation_economic/resource/resource.dart';

class QuestionCommonModel {
  String? cauHoiUUID;
  int? maPhieu;
  String? maCauHoi;
  int? manHinh;
  String? maCauHoiCha;
  String? tenCauHoi;
  int? sTT;
  int? hienThi;
  int? cap;
  String? maSo;
  String? dVT;
  int? loaiCauHoi;
  //String? tenLoaiCauHoi;
  String? bangChiTieu;
  int? loaiCanhBao;
//  String? hienThiTheoMaIO;
  String? maIODinhDanh;
  String? dieuKienMaIO;
  String? buocNhay;
  double? giaTriNN;
  double? giaTriLN;
  String? bangDuLieu;
  String? giaiThich;
  List<QuestionCommonModel>? danhSachCauHoiCon;
  List<ChiTieuDongModel>? danhSachChiTieuIO;
  List<ChiTieuModel>? danhSachChiTieu;
//  List<ChiTieuKhoaModel>? danhSachChiTieuKhoa;
  //List<DiaDiemSXKDModel>? diaDiemBSXKD;

  QuestionCommonModel(
      {this.cauHoiUUID,
      this.maPhieu,
      this.maCauHoi,
      this.manHinh,
      this.maCauHoiCha,
      this.tenCauHoi,
      this.sTT,
      this.hienThi,
      this.cap,
      this.maSo,
      this.dVT,
      this.loaiCauHoi,
      //  this.tenLoaiCauHoi,
      this.bangChiTieu,
      this.loaiCanhBao,
    //  this.hienThiTheoMaIO,
      this.maIODinhDanh,
      this.dieuKienMaIO,
      this.buocNhay,
      this.giaTriNN,
      this.giaTriLN,
      this.bangDuLieu,
      this.giaiThich,
      this.danhSachCauHoiCon,
      this.danhSachChiTieuIO,
      this.danhSachChiTieu });

  QuestionCommonModel.fromJson(dynamic json) {
    cauHoiUUID = AppUtils().getCustomUniqueId();
    maPhieu = json['MaPhieu'];
    maCauHoi = json['MaCauHoi'];
    manHinh = json['ManHinh'];
    maCauHoiCha = json['MaCauHoiCha'];
    tenCauHoi = json['TenCauHoi'];
    sTT = json['STT'];
    hienThi = json['HienThi'];
    cap = json['Cap'];
    maSo = json['MaSo'];
    dVT = json['DVT'];
    loaiCauHoi = json['LoaiCauHoi'];
    bangChiTieu = json['BangChiTieu'];
    loaiCanhBao = json['LoaiCanhBao'];
   // hienThiTheoMaIO = json['HienThiTheoMaIO'];
    maIODinhDanh = json['MaIODinhDanh'];
    dieuKienMaIO = json['DieuKienMaIO'];
    buocNhay = json['BuocNhay'];
    giaTriNN = json['GiaTriNN'];
    giaTriLN = json['GiaTriLN'];
    bangDuLieu = json['BangDuLieu'];
    giaiThich = json['GiaiThich'];
    if (json['DM_CauHoiCon'] != null) {
      danhSachCauHoiCon = [];
      json['DM_CauHoiCon'].forEach((v) {
        danhSachCauHoiCon?.add(QuestionCommonModel.fromJson(v));
      });
    }
    if (json['DM_CauHoi_ChiTieuBang_Cots'] != null) {
      danhSachChiTieu = [];
      json['DM_CauHoi_ChiTieuBang_Cots'].forEach((v) {
        danhSachChiTieu?.add(ChiTieuModel.fromJson(v));
      });
    }
    if (json['DM_CauHoi_ChiTieuBang_Dongs'] != null) {
      danhSachChiTieuIO = [];
      json['DM_CauHoi_ChiTieuBang_Dongs'].forEach((v) {
        danhSachChiTieuIO?.add(ChiTieuDongModel.fromJson(v));
      });
    }
    // if (json['DM_CauHoi_ChiTieuKhoas'] != null) {
    //   danhSachChiTieuKhoa = [];
    //   json['DM_CauHoi_ChiTieuKhoas'].forEach((v) {
    //     danhSachChiTieuKhoa?.add(ChiTieuKhoaModel.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MaCauHoiUUID'] = cauHoiUUID;
    data['MaPhieu'] = maPhieu;
    data['MaCauHoi'] = maCauHoi;
    data['ManHinh'] = manHinh;
    data['MaCauHoiCha'] = maCauHoiCha;
    data['TenCauHoi'] = tenCauHoi;
    data['STT'] = sTT;
    data['HienThi'] = hienThi;
    data['Cap'] = cap;
    data['MaSo'] = maSo;
    data['DVT'] = dVT;
    data['LoaiCauHoi'] = loaiCauHoi;
    data['BangChiTieu'] = bangChiTieu;
    data['LoaiCanhBao'] = loaiCanhBao;
   // data['HienThiTheoMaIO'] = hienThiTheoMaIO;
    data['MaIODinhDanh'] = maIODinhDanh;
    data['DieuKienMaIO'] = dieuKienMaIO;
    data['BuocNhay'] = buocNhay;
    data['GiaTriNN'] = giaTriNN;
    data['GiaTriLN'] = giaTriLN;
    data['BangDuLieu'] = bangDuLieu;
    data['GiaiThich'] = giaiThich;
    if (danhSachCauHoiCon != null) {
      data['DM_CauHoiCon'] = danhSachCauHoiCon?.map((v) => v.toJson()).toList();
    }
    if (danhSachChiTieu != null) {
      data['DM_CauHoi_ChiTieuBang_Cots'] =
          danhSachChiTieu?.map((v) => v.toJson()).toList();
    }
    if (danhSachChiTieuIO != null) {
      data['DM_CauHoi_ChiTieuBang_Dongs'] =
          danhSachChiTieuIO?.map((v) => v.toJson()).toList();
    }
    // if (danhSachChiTieuKhoa != null) {
    //   data['DM_CauHoi_ChiTieuKhoas'] =
    //       danhSachChiTieuKhoa?.map((v) => v.toJson()).toList();
    // }
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
