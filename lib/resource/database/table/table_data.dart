import 'dart:convert';

import 'package:gov_statistics_investigation_economic/config/constants/app_define.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_cap.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_ct_dm_quoctich.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_cokhong.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dantoc.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_dia_ban_coso_sxkd.dart'; 
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_gioitinh.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_linhvuc.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_mota_sanpham.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_tinhtranghd.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_trangthaidt.dart';
import 'package:gov_statistics_investigation_economic/resource/database/table/table_dm_doituong_dieutra.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/active_status_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/business_location_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/dm_common_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/dm_dantoc_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/dm_mota_sanpham_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/investigate_object_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/investigate_status_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/store/nhomnhanh_vcpa_model.dart';
import 'package:gov_statistics_investigation_economic/resource/model/subject/subject_model.dart';

import 'table_dm07mau.dart'; 

///Chưa danh sánh câu hỏi của mỗi phiếu
///
const String tableData = 'DataInfo';
const String columnDataId = '_id';
const String columnDataMaDTV = 'MaDTV';
const String columnDataQuestionMau = 'CauHoiPhieu07Maus';
const String columnDataQuestionTB = 'CauHoiPhieu07TBs';
const String columnDataQuestionTonGiao = 'CauHoiPhieu08TonGiaos';
const String columnDataCreatedAt = 'CreatedAt';
const String columnDataUpdatedAt = 'UpdatedAt';

class TableData {
  int? id;
  String? maDTV;
  String? questionNo07Mau;
  String? questionNo07TB;
  String? questionNo08;
  String? createdAt;
  String? updatedAt;

  TableData({
    this.id,
    this.maDTV,
    this.questionNo07Mau,
    this.questionNo07TB,
    this.questionNo08,
    this.createdAt,
    this.updatedAt,
  });

  TableData.fromJson(dynamic dataJson) {
    createdAt = dataJson['CreatedAt'];
    updatedAt = dataJson['UpdatedAt'];
    maDTV = dataJson['MaDTV'];
    questionNo07Mau = jsonEncode(dataJson['CauHoiPhieu07Maus']);
    questionNo07TB = jsonEncode(dataJson['CauHoiPhieu07TBs']);
    questionNo08 = jsonEncode(dataJson['CauHoiPhieu08TonGiaos']);
  }

  Map<String, Object?> toJson() {
    var map = <String, Object?>{};
    map['MaDTV'] = maDTV;
    map['CauHoiPhieu07Maus'] = questionNo07Mau;
    map['CauHoiPhieu07TBs'] = questionNo07TB;
    map['CauHoiPhieu08TonGiaos'] = questionNo08;
    map['CreatedAt'] = createdAt;
    map['UpdatedAt'] = updatedAt;
    return map;
  }

  dynamic toCauHoiPhieu07Mau() {
    return jsonDecode(questionNo07Mau!);
  }

  dynamic toCauHoiPhieu07TB() {
    return jsonDecode(questionNo07TB!);
  }

  dynamic toCauHoiPhieu08() {
    return jsonDecode(questionNo08!);
  }

  dynamic toCauHoiPhieu07(String maDoiTuongDT) {
    if (maDoiTuongDT == AppDefine.maDoiTuongDT_07Mau.toString()) {
      return jsonDecode(questionNo07Mau!);
    } else if (maDoiTuongDT == AppDefine.maDoiTuongDT_07TB.toString()) {
      return jsonDecode(questionNo07TB!);
    }
  }

  ///
  static List<TableDoiTuongDieuTra> toListDoiTuongDieuTras(dynamic json) {
    List<InvestigateObjectModel> subject =
        InvestigateObjectModel.listFromJson(json);
    List<TableDoiTuongDieuTra> danhSachDoiTuongDT = [];

    for (var element in subject) {
      if (element.maDoiTuongDT != 3) {
        danhSachDoiTuongDT.add(TableDoiTuongDieuTra(
            id: 0,
            maDoiTuongDT: element.maDoiTuongDT,
            tenDoiTuongDT: element.tenDoiTuongDT,
            moTaDoiTuongDT: element.moTaDoiTuongDT));
      }
    }
    return danhSachDoiTuongDT;
  }

  ///
  ///Danh sách ĐỊA BÀN CƠ SỞ SẢN XUẤT KINH DOANH
  static List<TableDmDiaBanCosoSxkd> toListDiaBanCoSoSXKDs(dynamic json) {
    List<SubjectModel> subject = SubjectModel.listFromJson(json);
    List<TableDmDiaBanCosoSxkd> danhSachDiaBan = [];

    for (var element in subject) {
      if (element.danhSachDiaBanCSSXKD != null) {
        danhSachDiaBan.addAll(List<TableDmDiaBanCosoSxkd>.from(element
            .danhSachDiaBanCSSXKD
            .map((model) => TableDmDiaBanCosoSxkd.fromJson(model))));
      }
    }
    return danhSachDiaBan;
  }

  ///Danh sách xã/phường thị trấn
  

  static List<TableDmTinhTrangHD> toListTinhTrangHDs(dynamic json) {
    List<ActiveStatusModel> subject = ActiveStatusModel.listFromJson(json);
    List<TableDmTinhTrangHD> dsTinhTrangHD = [];

    for (var element in subject) {
      dsTinhTrangHD.add(TableDmTinhTrangHD(
          id: 0,
          maTinhTrang: element.maTinhTrang,
          tenTinhTrang: element.tenTinhTrang,
          maDoiTuongDT: element.maDoiTuongDT));
    }
    return dsTinhTrangHD;
  }

  static List<TableDmTrangThaiDT> toListTrangThaiDTs(dynamic json) {
    List<InvestigateStatusModel> subject =
        InvestigateStatusModel.listFromJson(json);
    List<TableDmTrangThaiDT> dsTrangThaiDT = [];

    for (var element in subject) {
      dsTrangThaiDT.add(TableDmTrangThaiDT(
          id: 0,
          maTrangThaiDT: element.maTrangThaiDT,
          tenTrangThaiDT: element.tenTrangThaiDT));
    }
    return dsTrangThaiDT;
  }

  static List<TableDmCoKhong> toListDmCoKhongs(dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableDmCoKhong> dm = [];

    for (var element in subject) {
      dm.add(TableDmCoKhong(id: 0, ma: element.ma, ten: element.ten));
    }
    return dm;
  }

  static List<TableDmGioiTinh> toListDmGioiTinhs(dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableDmGioiTinh> dm = [];

    for (var element in subject) {
      dm.add(TableDmGioiTinh(id: 0, ma: element.ma, ten: element.ten));
    }
    return dm;
  }

  static List<TableDmDanToc> toListDmDanTocs(dynamic json) {
    List<DmDanTocModel> subject = DmDanTocModel.listFromJson(json);
    List<TableDmDanToc> dm = [];

    for (var element in subject) {
      dm.add(TableDmDanToc(
          id: 0,
          maDanToc: element.maMaDanToc,
          tenDanToc: element.tenDanToc,
          tenGoiKhac: element.tenGoiKhac,
          stt: element.stt));
    }
    return dm;
  }

  /*************/
  ///BEGIN::Danh mục cho phiếu 07 mẫu
  static List<TableDmCap> toListCTDmCaps(dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableDmCap> dm = [];

    for (var element in subject) {
      dm.add(TableDmCap(id: 0, ma: element.ma, ten: element.ten));
    }
    return dm;
  }

  static List<TableCTDmHoatDongLogistic> toListCTDmHoatDongLogistics(
      dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableCTDmHoatDongLogistic> dm = [];

    for (var element in subject) {
      dm.add(
          TableCTDmHoatDongLogistic(id: 0, ma: element.ma, ten: element.ten));
    }
    return dm;
  }

  static List<TableCTDmDiaDiemSXKD> toListCTDiaDiemSXKDs(dynamic json) {
    List<BusinessLocationModel> subject =
        BusinessLocationModel.listFromJson(json);
    List<TableCTDmDiaDiemSXKD> dm = [];

    for (var element in subject) {
      dm.add(TableCTDmDiaDiemSXKD(
          id: 0, ma: element.ma, ten: element.ten, ghiRo: element.ghiRo));
    }
    return dm;
  }

  static List<TableCTDmHoatDongLogistic> toListCTHoatDongLogistics(
      dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableCTDmHoatDongLogistic> dsDiaDiem = [];

    for (var element in subject) {
      dsDiaDiem.add(
          TableCTDmHoatDongLogistic(id: 0, ma: element.ma, ten: element.ten));
    }
    return dsDiaDiem;
  }

  static List<TableCTDmLinhVuc> toListCTLinhVucs(dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableCTDmLinhVuc> dsDiaDiem = [];

    for (var element in subject) {
      dsDiaDiem.add(TableCTDmLinhVuc(id: 0, ma: element.ma, ten: element.ten));
    }
    return dsDiaDiem;
  }

  static List<TableCTDmLoaiDiaDiem> toListCTLoaiDiaDiems(dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableCTDmLoaiDiaDiem> dsDiaDiem = [];

    for (var element in subject) {
      dsDiaDiem
          .add(TableCTDmLoaiDiaDiem(id: 0, ma: element.ma, ten: element.ten));
    }
    return dsDiaDiem;
  }

  static List<TableCTDmQuocTich> toListCTDmQuocTichs(dynamic json) {
    List<DmQuocTichModel> subject = DmQuocTichModel.listFromJson(json);
    List<TableCTDmQuocTich> dsDiaDiem = [];

    for (var element in subject) {
      dsDiaDiem.add(TableCTDmQuocTich(
          id: 0,
          maQuocTich: element.maQuocTich,
          tenQuocTich: element.tenQuocTich));
    }
    return dsDiaDiem;
  }

  static List<TableCTDmTinhTrangDKKD> toListCTDmTinhTrangSXKDs(dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableCTDmTinhTrangDKKD> dsDiaDiem = [];

    for (var element in subject) {
      dsDiaDiem
          .add(TableCTDmTinhTrangDKKD(id: 0, ma: element.ma, ten: element.ten));
    }
    return dsDiaDiem;
  }

  static List<TableCTDmTrinhDoChuyenMon> toListCTDmTrinhDoChuyenMons(
      dynamic json) {
    List<DmCommonModel> subject = DmCommonModel.listFromJson(json);
    List<TableCTDmTrinhDoChuyenMon> dsDiaDiem = [];

    for (var element in subject) {
      dsDiaDiem.add(
          TableCTDmTrinhDoChuyenMon(id: 0, ma: element.ma, ten: element.ten));
    }
    return dsDiaDiem;
  }

  static List<TableCTDmNhomNganhVcpa> toListNganhVcpas(dynamic json) {
    List<NhomnhanhVcpaModel> subject = NhomnhanhVcpaModel.listFromJson(json);
    List<TableCTDmNhomNganhVcpa> dsVsic = [];

    for (var element in subject) {
      dsVsic.add(TableCTDmNhomNganhVcpa(
          id: 0,
          cap5: element.cap5,
          donViTinh: element.donViTinh,
          moTaNganhSanPham: element.moTaNganhSanPham,
          linhVuc: element.linhVuc));
    }
    return dsVsic;
  }

  static List<TableDmLinhvuc> toListDmLinhVuc(dynamic json) {
    List<DmLinhVucModel> subject = DmLinhVucModel.listFromJson(json);
    List<TableDmLinhvuc> dmLv = [];

    for (var element in subject) {
      dmLv.add(
          TableDmLinhvuc(id: 0, maLV: element.ma, tenLinhVuc: element.ten));
    }
    return dmLv;
  }

  static List<TableDmMotaSanpham> toLisMoTaSanPhamVcpas(dynamic json) {
    List<DmMotaSanphamModel> subject = DmMotaSanphamModel.listFromJson(json);
    List<TableDmMotaSanpham> dsVsic = [];

    for (var element in subject) {
      dsVsic.add(TableDmMotaSanpham(
          id: 0,
          maSanPham: element.maSanPham,
          tenSanPham: element.tenSanPham,
          tenSanPhamKoDau: element.tenSanPhamKoDau,
          moTaChiTiet: element.moTaChiTiet,
          moTaChiTietKoDau: element.moTaChiTietKoDau,
          donViTinh: element.donViTinh,
          maLV: element.maLV,
          tenLinhVuc: element.tenLinhVuc));
    }
    return dsVsic;
  }

  ///END::Danh mục cho phiếu 07 mẫu
  ///
/*************/ 
}
