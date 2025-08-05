class ApiConstants {
  // statusCode
  static const int success = 200;
  static const int errorToken = 401;

  static const int errorValidate = 422;
  static const int errorServer = 500;
  static const int errorDisconnect = -1;
  static const int noContent = 204;

  ///Thêm mới by tuannb: Cho trường hợp lỗi thuộc loại exception
  static const int errorException = 600;
  static const String responseSuccess = '000'; // "Đã thực hiện thành công"
  static const String errorSaveFile = '601'; // "Lỗi lưu tập tin"
  static const String errorMaDTVNotFound =
      '602'; // "Lỗi KHÔNG TÌM THẤY MÃ ĐIỀU TRA VIÊN"
  static const String notAllowSendFile =
      '603'; // "Chưa được phân quyền gửi file ở CT_QL_PhanQuyenNghiepVu"
  static const String removeOldVersion = '606';
  static const String installNewVersion = '607';
  static const String cuocDieuTraChuaMo = '608';
  static const String khoaCAPI = '609';
  static const String khongTimThayNguoiDungCAPI = '610';
  static const String loiLayDuLieuPhongVan = '611';

  ///Vui lòng cập nhật Version {0} để lấy dữ liệu điều tra!
  static const String capNhatPhienBanMoi = '612';
  static const String loiDongBo = '613';
  static const String invalidModelSate = '614';
  static const String duLieuDongBoRong = '615';
  static const String requestTimeOut = '408';
  static const String modelAILastestVersion = '620';

  //dev http://v1_capi_giasanxuat.gso.gov.vn/
  //live: http://api_cathe_thidiemtdtkt2026.gso.gov.vn/
  static const String baseUrl = String.fromEnvironment('BASE_API',
      defaultValue: "http://api_cathe_thidiemtdtkt2026.gso.gov.vn/");

  static const String baseUrlNganhSp = "http://sic3_api1.gso.gov.vn:8000/";

  // define
  static const String basicUserName = 'KT';
  static const String basicPass = '59E63FC7-388E-46B8-8A22-DA12C56F3398';

  // auth
  static const String getToken = '/token';
  static const String getUser = 'api/SICNguoiDungCAPIs';
  static const String changePassword = 'api/SICChangePwdCAPIs';

  // data
  static const String getData = 'api/LayThongTinDuLieu';

  //sync data
  static const String sync = 'api/SyncData/';

  //send error data
  static const String sendErrorData = 'api/LogErrorData/';

  /// ky dieu tra
  static const String getKyDieuTra = 'api/GetKyDieuTra';

  // ky dieu tra
  static const String getCheckVersion = 'api/CheckVersionCaPi';

  static const String sendErrorLog = 'api/LogError';

  ///
  static const String getModelVersion = 'api/GetModelVersion';

  ///Xác nhận tự kê khai của cơ sở sxkd
  static const String postXacNhanTuKeKhai = 'api/XacNhanTuKeKhai';
}
