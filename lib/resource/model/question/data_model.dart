import 'package:gov_statistics_investigation_economic/resource/database/provider/provider.dart';

class DataModel {
  String? responseCode;
  String? responseDesc;
  String? versionDanhMuc;
  String? hasDm;
  dynamic data;

  dynamic cauHoiPhieu07Maus;
  dynamic cauHoiPhieu07TBs;
  dynamic cauHoiPhieu07MauMenu;
  dynamic cauHoiPhieu07TBMenu;
  dynamic cauHoiPhieu08s;
  dynamic dmCoKhong;
  dynamic dmGioiTinh;
  dynamic dmDanToc;
  dynamic danhSachTinhTrangHD;
  dynamic danhSachTrangThaiDT;
  dynamic dmMoTaSanPham;

  ///Danh mục lĩnh vực sản phẩm
  dynamic dmLinhVuc;
  //dynamic dmNganhVSICIOs;
  dynamic ctDmCap;
  dynamic ctDmDiaDiemSXKDDtos;
  dynamic ctDmHoatDongLogistic;
  dynamic ctDmLinhVuc;
  dynamic ctDmLoaiDiaDiem;
  dynamic ctDmTinhTrangDKKD;
  dynamic ctDmTrinhDoChuyenMon;
  dynamic ctDmQuocTich;
  dynamic tgDmCapCongNhan;
  dynamic tgDmLoaiCoSo;
   
  dynamic tgDmNangLuong;
  dynamic tgDmSuDungPhanMem;
  dynamic tgDmTrinhDoChuyenMon;
  dynamic tgDmXepHang;
  dynamic tgDmXepHangDiTich;
 
  String? maSanPhamLoaiTruCoSoCT;
  dynamic dmPhieu;

  DataModel(
      {this.responseCode,
      this.responseDesc,
      this.versionDanhMuc,
      this.hasDm,
      this.data,
      this.cauHoiPhieu07Maus,
      this.cauHoiPhieu07TBs,
      this.cauHoiPhieu07MauMenu,
      this.cauHoiPhieu07TBMenu,
      this.cauHoiPhieu08s,
      this.danhSachTinhTrangHD,
      this.danhSachTrangThaiDT,
      //this.dmNganhVSICIOs,
      this.dmMoTaSanPham,
      this.dmLinhVuc,
      this.ctDmCap,
      this.ctDmHoatDongLogistic,
      this.ctDmDiaDiemSXKDDtos,
      this.ctDmLinhVuc,
      this.ctDmLoaiDiaDiem,
      this.ctDmTinhTrangDKKD,
      this.ctDmTrinhDoChuyenMon,
      this.ctDmQuocTich,
      this.tgDmCapCongNhan,
      this.tgDmLoaiCoSo,
   
      this.tgDmNangLuong,
      this.tgDmSuDungPhanMem,
      this.tgDmTrinhDoChuyenMon,
      this.tgDmXepHang,
      this.tgDmXepHangDiTich,
   
      this.maSanPhamLoaiTruCoSoCT,
      this.dmPhieu});

  DataModel.fromJson(dynamic json) {
    responseCode = json['ResponseCode'];
    responseDesc = json['ResponseDesc'];
    versionDanhMuc = json['VersionDm'];
    hasDm = json['HasDm'];
    data = json['Datas'];
    cauHoiPhieu07Maus = json['CauHoiPhieu07Maus'];
    cauHoiPhieu07TBs = json['CauHoiPhieu07TBs'];
    cauHoiPhieu07MauMenu = json['CauHoiPhieu07MauMenu'];
    cauHoiPhieu07TBMenu = json['CauHoiPhieu07TBMenu'];
   
    dmCoKhong = json['DM_CoKhong'];
    dmGioiTinh = json['DM_GioiTinh'];
    dmDanToc = json['DM_DanToc'];
    danhSachTinhTrangHD = json['DanhSachTinhTrangHD'];
    danhSachTrangThaiDT = json['DanhSachTrangThaiDT'];
    dmLinhVuc = json['DM_LinhVucDtos'];
    dmMoTaSanPham = json['DM_MoTaSanPhamDtos'];
    //dmNganhVSICIOs = json['DM_NganhVSIC_IOs'];
    ctDmDiaDiemSXKDDtos = json['CT_DM_DiaDiemSXKDDtos'];
    ctDmCap = json['CT_DM_Cap'];
    ctDmLinhVuc = json['CT_DM_LinhVuc'];
    ctDmHoatDongLogistic = json['CT_DM_HoatDongLogistic'];
    ctDmLoaiDiaDiem = json['CT_DM_LoaiDiaDiem'];
    ctDmTinhTrangDKKD = json['CT_DM_TinhTrangDKKD'];
    ctDmTrinhDoChuyenMon = json['CT_DM_TrinhDoChuyenMon'];
    ctDmQuocTich = json['CT_DM_QuocTich'];

    tgDmCapCongNhan = json['TG_DM_CapCongNhan'];
    tgDmLoaiCoSo = json['TG_DM_LoaiCoSo'];
    
    tgDmNangLuong = json['TG_DM_NangLuong'];
    tgDmSuDungPhanMem = json['TG_DM_SuDungPhanMem'];
    tgDmTrinhDoChuyenMon = json['TG_DM_TrinhDoChuyenMon'];
    tgDmXepHang = json['TG_DM_XepHang'];
    tgDmXepHangDiTich = json['TG_DM_XepHangDiTich'];
   
    maSanPhamLoaiTruCoSoCT = json['MaSanPhamLoaiTruCoSoCT'];
    dmPhieu = json['CT_DM_Phieu'];
  }

  dynamic toJson() {
    var map = <String, dynamic>{};
    map['ResponseCode'] = responseCode;
    map['ResponseDesc'] = responseDesc;
    map['VersionDm'] = versionDanhMuc;

    map['hasDm'] = hasDm;
    map['Datas'] = data;
    map['CauHoiPhieu07Maus'] = cauHoiPhieu07Maus;
    map['CauHoiPhieu07TBs'] = cauHoiPhieu07TBs;
  
    map['DM_CoKhong'] = dmCoKhong;
    map['DM_GioiTinh'] = dmGioiTinh;
    map['DM_DanToc'] = dmDanToc;
    map['DanhSachTinhTrangHD'] = danhSachTinhTrangHD;
    map['DanhSachTrangThaiDT'] = danhSachTrangThaiDT;

    map['DM_LinhVucDtos'] = dmLinhVuc;
    map['DM_MoTaSanPhamDtos'] = dmMoTaSanPham;
    //map['DM_NganhVSIC_IOs'] = dmNganhVSICIOs;
    map['CT_DM_Cap'] = ctDmCap;
    map['CT_DM_DiaDiemSXKDDtos'] = ctDmDiaDiemSXKDDtos;
    map['CT_DM_LinhVuc'] = ctDmLinhVuc;
    map['CT_DM_HoatDongLogistic'] = ctDmHoatDongLogistic;
    map['CT_DM_LoaiDiaDiem'] = ctDmLoaiDiaDiem;
    map['CT_DM_TinhTrangDKKD'] = ctDmTinhTrangDKKD;
    map['CT_DM_TrinhDoChuyenMon'] = ctDmTrinhDoChuyenMon;
    map['CT_DM_QuocTich'] = ctDmQuocTich;

    map['TG_DM_CapCongNhan'] = tgDmCapCongNhan;
    map['TG_DM_LoaiCoSo'] = tgDmLoaiCoSo;
 

    map['TG_DM_NangLuong'] = tgDmNangLuong;
    map['TG_DM_SuDungPhanMem'] = tgDmSuDungPhanMem;
    map['TG_DM_TrinhDoChuyenMon'] = tgDmTrinhDoChuyenMon;

    map['TG_DM_XepHang'] = tgDmXepHang;
    map['TG_DM_XepHangDiTich'] = tgDmXepHangDiTich;
   
    map['MaSanPhamLoaiTruCoSoCT'] = maSanPhamLoaiTruCoSoCT;
    map['CT_DM_Phieu'] = dmPhieu;
    return map;
  }
}
