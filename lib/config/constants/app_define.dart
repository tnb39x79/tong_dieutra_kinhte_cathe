import 'package:gov_statistics_investigation_economic/common/utils/utils.dart';

class AppDefine {
  AppDefine._();

  // Ma trang thai ho
  static const int hoPhongVan = 1;
  static const int hoKhongTonTai = 2;
  static const int hoKhongHopTac = 3;

  // Ma trang thai dieu tra
  ///chuaPhongVan = 1
  static const int chuaPhongVan = 1;

  ///dangPhongVan = 2
  static const int dangPhongVan = 2;

  ///hoanThanhPhongVan = 9
  static const int hoanThanhPhongVan = 9;

  // defind type question
  static const int checkBoxCircleWithString = 6;
  static const int inputTypeInterger = 2;
  static const int onlyTitle = 0;
  static const int checkBoxRegtangleWithInterger = 7;
  static const int checkBoxCircleWithInterger = 5;
  static const int inputTypeDemacial = 3;
  static const int inputTypeString = 4;
  static const int ynQuetion = 1;

  static const int maDoiTuongDT_07Mau = 5;
  static const int maDoiTuongDT_07TB = 0; 

  static const int loaiCauHoi_1 = 1;
  static const int loaiCauHoi_2 = 2;
  static const int loaiCauHoi_3 = 3;
  static const int loaiCauHoi_4 = 4;
  static const int loaiCauHoi_5 = 5;
  static const int loaiCauHoi_9 = 9;
  static const int loaiCauHoi_10 = 10;
  static const int loaiCauHoi_12 = 12;
  static const int loaiCauHoi_13 = 13;

  static const String maso_00 = '00';
  static const String maso_000 = '000';

  ///Bảng Chỉ tiêu IO CT_DM_CauHoi_ChiTieuIO
  ///1: Chỉ tiêu dòng của các câu hỏi có mã IO; 2: Chỉ tiêu dòng của các câu không có mã IO
  static const String loaiChiTieu_1 = '1';
  static const String loaiChiTieu_2 = '2';

  ///Bảng chỉ tiêu CT_DM_CauHoi_ChiTieu
  static const String maChiTieu_1 = '1'; //Cột 1
  static const String maChiTieu_2 = '2'; //Cột 2

  /// 1: Ngành công nghiệp;
  static const String loaiNganhIO_1 = '1';

  /// 2: Ngành thương mại, dịch vụ
  static const String loaiNganhIO_2 = '2';

  static const int soNamSuDungMin = 0;
  static const int soNamSuDungMax = 20;
  static const int giaMuaMin = 0;
  static const int giaMuaMin10000 = 10000;
  static const int giaMuaMax = 999999999;
  static const double minValueDefault = 0;
  static const double maxValueDefault = 999999999;

  ///ngin dong
  static const int namMuaMin = 1990;

  static const String waringText = 'Cảnh báo: ';
  static const String waringTextDialog = 'Dialog:';

  static const int maTinhTrangHDTuKeKhai = 6;
}
