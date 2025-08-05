const String ddSpId='Id';
const String ddSpSttSanPham='SttSanPham';
const String ddSpMaSanPham='MaSanPham';
const String ddSpIsCap1BCDE='IsCap1BCDE';
const String ddSpIsCap1GL='IsCap1GL';
const String ddSpIsCap2_56='IsCap2_56';
const String ddSpIsCap1H='IsCap1H';
const String ddSpIsCap5VanTaiHanhKhach='IsCap5VanTaiHanhKhach';
const String ddSpIsCap5DichVuHangHoa='IsCap5DichVuHangHoa';
const String ddSpIsCap2_55="IsCap2_55";


class DanhDauSanphamModel {


  int? id;
  int? sttSanPham;
  String? maSanPham;
  //[MÃ SẢN PHẨM CẤP 1 LÀ B-C-D-E] => HỎI CÂU 5.2 ĐẾN CÂU 5.3
  bool? isCap1BCDE;

  ///[MÃ SẢN PHẨM CẤP 1 LÀ G VÀ NGÀNH L6810  (TRỪ CÁC MÃ 4513-4520-45413-4542-461)] => HỎI CÂU 5.5
  bool? isCap1GL;

  ///[MÃ SẢN PHẨM CẤP 2 LÀ 56] => HỎI CÂU 5.6 và 5.6.1
  bool? isCap2_56;

  ///HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 1 LÀ NGÀNH H
  bool? isCap1H;

  ///HOẠT ĐỘNG VẬN TẢI HÀNH KHÁCH
  ///HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 5 LÀ 49210-49220-49290-49312-49313-49319-49321-49329-50111-50112-50211-50212
  bool? isCap5VanTaiHanhKhach;

  ///HOẠT ĐỘNG VẬN TẢI HÀNG HÓA
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 5 LÀ 49331-49332-49333-49334-49339-50121-50122-50221-50222)
  bool? isCap5DichVuHangHoa;

  ///VII. NĂNG LỰC PHỤC VỤ CỦA CƠ SỞ KINH DOANH DỊCH VỤ LƯU TRÚ
  ///(HIỂN THỊ CÂU HỎI ĐỐI VỚI MÃ VCPA CẤP 2 LÀ 55)
  bool? isCap2_55;

  DanhDauSanphamModel({
    this.id,
    this.sttSanPham,
    this.maSanPham,
    this.isCap1BCDE,
    this.isCap1GL,
    this.isCap2_56,
    this.isCap1H,
    this.isCap5VanTaiHanhKhach,
    this.isCap5DichVuHangHoa,
    this.isCap2_55,
  });

  DanhDauSanphamModel.fromJson(Map json) {
    id = json['Id'];
    sttSanPham = json['STTSanPham'];
    maSanPham = json['MaSanPham'];

    isCap1BCDE = json['IsCap1BCDE'];
    isCap1GL = json['IsCap1GL'];
    isCap2_56 = json['IsCap2_56'];
    isCap1H = json['IsCap1H'];
    isCap5VanTaiHanhKhach = json['IsCap5VanTaiHanhKhach'];
    isCap5DichVuHangHoa = json['IsCap5DichVuHangHoa'];
    isCap2_55 = json['IsCap2_55'];
  }

  dynamic toJson() {
    var map = <String, dynamic>{};
    map['Id'] = id;
    map['STTSanPham'] = sttSanPham;
    map['MaSanPham'] = maSanPham;
    map['IsCap1BCDE'] = isCap1BCDE;
    map['IsCap1GL'] = isCap1GL;
    map['IsCap2_56'] = isCap2_56;
    map['IsCap1H'] = isCap1H;
    map['IsCap5VanTaiHanhKhach'] = isCap5VanTaiHanhKhach;
    map['IsCap5DichVuHangHoa'] = isCap5DichVuHangHoa;
    map['IsCap2_55'] = isCap2_55;
    return map;
  }
}
